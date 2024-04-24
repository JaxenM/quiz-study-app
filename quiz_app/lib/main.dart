import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'pages/home_page.dart';
import 'pages/opening_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF0A092D); // Hex for background
    const primaryColor =
        Color(0xFF2E3856); // Hex for AppBar and other components
    const textColor = Color(0xFFF6F7FB); // Hex for text

    return MaterialApp(
      title: 'Quiz App',
      localizationsDelegates: const [
        AppLocalizations.delegate, // Localization delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        fontFamily: 'MyCustomFont',
        primaryColor: primaryColor, // Update primary color
        scaffoldBackgroundColor: backgroundColor, // Update background
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor, // Update AppBar color
          foregroundColor: textColor, // Update AppBar text color
        ),
        textTheme: TextTheme(
          bodyLarge: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: textColor, // Update text color
          ),
          bodyMedium: TextStyle(
            fontSize: 14.0,
            color: textColor.withOpacity(0.6),
          ),
          displayLarge: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor, // Button background color
          foregroundColor: textColor, // Button text color
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: textColor,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundColor,
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
        ),
        textTheme: TextTheme(
          bodyLarge: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: textColor,
          ),
          bodyMedium: TextStyle(
            fontSize: 14.0,
            color: textColor.withOpacity(0.6),
          ),
          displayLarge: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: textColor,
          ),
        ),
      ),
      themeMode: ThemeMode.system, // Use system default
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null) {
              return const HomePage(); // Use the correct home
            } else {
              return const OpeningPage();
            }
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
