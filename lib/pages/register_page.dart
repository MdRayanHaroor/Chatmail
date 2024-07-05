import 'package:flutter/material.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  void Function()? onTap;

  RegisterPage({Key? key, required this.onTap}) : super(key: key);

  void register(BuildContext context) {
    final _auth = AuthService();
    if (_pwController.text == _confirmPwController.text) {
      // Validate email
      if (_validateEmail(_emailController.text)) {
        // Validate password
        if (_validatePassword(_pwController.text)) {
          try {
            _auth.signUpWithEmailPassWord(
              _emailController.text,
              _pwController.text,
            );
          } catch (e) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ),
            );
          }
        } else {
          // Password does not meet the criteria
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "Password must be at least 8 characters long and contain a combination of letters, numbers, and symbols.",
              ),
            ),
          );
        }
      } else {
        // Invalid email
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Please enter a valid email address."),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
    }
  }

  // Validate email function
  bool _validateEmail(String value) {
    // Simple email validation using RegExp
    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  // Validate password function
  bool _validatePassword(String value) {
    // Password must be at least 8 characters long
    if (value.length < 8) return false;

    // Password must contain at least one letter, one number, and one symbol
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
    final hasNumber = RegExp(r'[0-9]').hasMatch(value);
    final hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    return hasLetter && hasNumber && hasSymbol;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 50),
              Text(
                "Let's create an account for you!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: _emailController,
                hintText: "Email",
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!_validateEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _pwController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: _confirmPwController,
                hintText: "Confirm Password",
                obscureText: true,
              ),
              const SizedBox(height: 25),
              MyButton(
                onTap: () => register(context),
                text: "Register",
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
