import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'create_account_page.dart';
import 'sign_in_account_page.dart';

class OpeningPage extends StatelessWidget {
  const OpeningPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localized strings
    const primaryColor = Color(0xFF2E3856); // Consistent primary color
    const textColor = Color(0xFFF6F7FB); // Consistent text color

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.openingPageTitle), // Localized title
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false, // No back button
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10.0), // Vertical spacing
              child: Text(
                loc.openingPageWelcomeMessage, // Localized welcome message
                style: const TextStyle(
                  fontSize: 18,
                  color: textColor, // Consistent text color
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                loc.openingPageSignInMessage, // Localized sign-in message
                style: const TextStyle(
                  fontSize: 16,
                  color: textColor, // Consistent text color
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAccountPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: primaryColor, // Button color matching AppBar
              ),
              child: Text(
                loc.createAccount, // Localized create account button text
                style: const TextStyle(
                  color: textColor, // Consistent button text color
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInAccountPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: primaryColor, // Same color as "Create Account"
              ),
              child: Text(
                loc.signIn, // Localized sign-in button text
                style: const TextStyle(
                  color: textColor, // Consistent button text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
