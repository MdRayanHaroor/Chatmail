import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../themes/theme_provider.dart';
import '../pages/changepassword.dart';


class ProfilePage extends StatelessWidget {
  final User? currentUser;

  const ProfilePage({Key? key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey.shade600,
        elevation: 0,
      ),
      backgroundColor: themeProvider.isDarkMode
          ? Theme.of(context).colorScheme.background
          : Theme.of(context).colorScheme.background,
      body: Container(
        width: 400,
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Email:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isDarkMode
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              subtitle: Text(
                currentUser?.email ?? 'No email available',
                style: TextStyle(
                  fontSize: 16,
                  color: themeProvider.isDarkMode
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            Divider(), // Add a divider for visual separation
            ListTile(
              title: Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isDarkMode
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              onTap: () {
                // Navigate to the change password screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
