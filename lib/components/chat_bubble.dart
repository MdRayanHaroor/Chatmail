import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {

  final String message;
  final bool isCurrentUser;


  const ChatBubble({super.key, required this.isCurrentUser, required this.message});

  @override
  Widget build(BuildContext context) {
    //light vs dark mode for corrext bubble colors
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500) : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      child: Text(
        message,
        style: TextStyle(color: isDarkMode ? Colors.white : (isDarkMode ? Colors.white :Colors.black)), 
      ),     
    );
  }
}