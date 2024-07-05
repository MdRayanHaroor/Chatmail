import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPasswordField(_oldPasswordController, 'Old Password', _obscureOldPassword, () {
              setState(() {
                _obscureOldPassword = !_obscureOldPassword;
              });
            }),
            SizedBox(height: 20),
            _buildPasswordField(_newPasswordController, 'New Password', _obscureNewPassword, () {
              setState(() {
                _obscureNewPassword = !_obscureNewPassword;
              });
            }),
            SizedBox(height: 20),
            _buildPasswordField(_confirmPasswordController, 'Confirm New Password', _obscureConfirmPassword, () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String labelText, bool obscureText, void Function() onTap) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: onTap,
        ),
      ),
      obscureText: obscureText,
    );
  }

  void _changePassword() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      // User not authenticated
      return;
    }

    try {
      // Reauthenticate user
      final credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: _oldPasswordController.text,
      );

      await currentUser.reauthenticateWithCredential(credential);

      // Check if new password matches confirm password
      if (_newPasswordController.text != _confirmPasswordController.text) {
        // Passwords don't match
        throw 'Passwords do not match';
      }

      // Change password
      await currentUser.updatePassword(_newPasswordController.text);

      // Password changed successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully')),
      );

      // Clear text fields
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      // Error changing password
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
