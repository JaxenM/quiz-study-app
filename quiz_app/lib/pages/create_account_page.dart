import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/string_validator.dart';
import '../services/auth.dart';
import 'home_page.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localized strings
    const primaryColor = Color(0xFF2E3856); // Primary color
    const textColor = Color(0xFFF6F7FB); // Consistent text color

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.createAccount,
          style: const TextStyle(color: textColor), // Consistent text color
        ),
        backgroundColor: primaryColor, // Consistent app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Consistent padding
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Move content to the top
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Stretch to fill width
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: loc.emailAddress, // Localized label
                  labelStyle: const TextStyle(
                      color: textColor), // Consistent text color
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    validateEmailAddress(value), // Email validator
              ),
              TextFormField(
                controller: _pwController,
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
              Padding(
                padding: const EdgeInsets.only(top: 20.0), // Consistent spacing
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor, // Consistent button color
                  ),
                  child: Text(
                    loc.createAccount, // Localized text
                    style: const TextStyle(
                        color: textColor), // Consistent button text color
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final String? result =
                          await Auth().createAccountWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _pwController.text.trim(),
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
                          _errorMessage = result; // Error handling
                        });
                      }
                    }
                  },
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
    _pwController.dispose();
    super.dispose();
  }
}
