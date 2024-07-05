import '../components/user_tile.dart';
import '../services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import '../components/my_drawer.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  late Stream<List<Map<String, dynamic>>> _usersStream;

  @override
  void initState() {
    super.initState();
    _refreshUserList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshUserList() async {
    setState(() {
      _usersStream = _chatService.getUserStream();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey.shade600,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchTextChanged,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshUserList,
              child: _buildUserList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _usersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0), // Add padding from the top
            child: CircularProgressIndicator(),
          );
        }
        final List<Map<String, dynamic>> users = snapshot.data ?? [];
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index];
            if (userData["email"] != _authService.getCurrentUser()!.email) {
              return UserTile(
                text: userData["email"],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiverEmail: userData["email"],
                        receiverID: userData["uid"],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      _usersStream = _chatService.getUserStream().map((users) {
        return users.where((user) {
          final userEmail = user["email"] as String;
          return userEmail.toLowerCase().contains(text.toLowerCase());
        }).toList();
      });
    });
  }
}