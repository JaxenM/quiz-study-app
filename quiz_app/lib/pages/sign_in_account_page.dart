import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/string_validator.dart';
import '../services/auth.dart';
import 'home_page.dart';

class SignInAccountPage extends StatefulWidget {
  const SignInAccountPage({super.key});

  @override
  _SignInAccountPageState createState() => _SignInAccountPageState();
}

class _SignInAccountPageState extends State<SignInAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localized strings
    const primaryColor = Color(0xFF2E3856); // Primary color
    const textColor = Color(0xFFF6F7FB); // Consistent text color

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.signIn,
          style: const TextStyle(color: textColor), // Consistent text color
        ),
        backgroundColor: primaryColor, // Consistent app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Consistent padding
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Stretch to fill width
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: loc.email, // Localized label
                  labelStyle: const TextStyle(
                      color: textColor), // Consistent text color
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    validateEmailAddress(value), // Email validator
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: loc.password, // Localized label
                  labelStyle: const TextStyle(
                      color: textColor), // Consistent text color
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    validatePassword(value), // Password validator
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0), // Consistent spacing
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor, // Consistent button color
                  ),
                  child: Text(
                    loc.signIn, // Localized text
                    style: const TextStyle(
                        color: textColor), // Consistent button text color
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final String? result =
                          await Auth().signInWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      if (!mounted) return;
                      if (result == null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      } else {
                        setState(() {
                          _errorMessage =
                              loc.signInError; // Localized error message
                        });
                      }
                    }
                  },
                ),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red, // Consistent error message color
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
