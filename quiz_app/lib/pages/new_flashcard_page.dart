import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import '../controllers/flashcard_controller.dart';
import '../model/flashcard.dart';

class NewFlashcardPage extends StatefulWidget {
  const NewFlashcardPage({super.key});

  @override
  _NewFlashcardPageState createState() => _NewFlashcardPageState();
}

class _NewFlashcardPageState extends State<NewFlashcardPage> {
  late TextEditingController _questionController;
  late TextEditingController _answerController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
    _answerController = TextEditingController();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localize

    const Color customTextColor = Color(0xFFF6F7FB); // Define custom color

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(loc.addNewFlashcard)), // Localized title
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _questionController,
            minLines: 1,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: loc.question, // Localized label
              labelStyle: const TextStyle(color: customTextColor), // Set color
              border: const OutlineInputBorder(),
            ),
            style:
                const TextStyle(color: customTextColor), // Apply color to text
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _answerController,
            minLines: 1,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: loc.answer, // Localized label
              labelStyle: const TextStyle(color: customTextColor), // Set color
              border: const OutlineInputBorder(), // Optional border
            ),
            style:
                const TextStyle(color: customTextColor), // Apply color to text
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_questionController.text.isEmpty ||
                  _answerController.text.isEmpty) {
                _showSnackbar(loc.requiredFieldsError);
              } else {
                var newFlashcard = Flashcard(
                    question: _questionController.text,
                    answer: _answerController.text);
                FlashcardController().insertFlashcard(newFlashcard);
                _showSnackbar(loc.flashcardAdded);
                Navigator.of(context).pop();
              }
            },
            child: Text(
              loc.save,
              style: const TextStyle(
                  color: customTextColor), // Color for button text
            ), // Localized button text
          ),
        ],
      ),
    );
  }
}
