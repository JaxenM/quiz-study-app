import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/pages/quiz_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/flashcard_controller.dart';
import '../model/flashcard.dart';
import 'new_flashcard_page.dart';
import '../services/auth.dart';
import 'opening_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlashcardController _flashcardController = FlashcardController();
  List<Flashcard> _flashcards = [];
  final Map<String, bool> _answerVisibility = {};
  StreamSubscription<List<Flashcard>>? _flashcardSubscription;

  @override
  void initState() {
    super.initState();
    _flashcardSubscription = _flashcardController.getStream().listen(
      (List<Flashcard> flashcards) {
        setState(() {
          _flashcards = flashcards;
        });
      },
      onError: (error) {
        print("Error fetching flashcards: $error");
      },
    );
  }

  @override
  void dispose() {
    _flashcardSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF2E3856); // Constant for primary color
    const textColor = Color(0xFFF6F7FB); // Constant for text color
    const disabledColor = Color(0xFFB0B3C1); // Constant for disabled color

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.school,
                color: textColor), // Non-const declaration
            onPressed: () {
              if (_flashcards.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(flashcards: _flashcards),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc.noFlashcardsAvailable,
                        style: const TextStyle(
                            color: textColor)), // Non-const TextStyle
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (_, index) =>
            _flashcardWidget(_flashcards[index], textColor), // Pass text color
        separatorBuilder: (_, __) => const Divider(),
        itemCount: _flashcards.length,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewFlashcardPage()),
          );
        },
        child:
            const Icon(Icons.add, color: textColor), // Use non-const for icons
      ),
      drawer: Drawer(
        backgroundColor: primaryColor, // Match AppBar color
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  loc.signOut,
                  style:
                      const TextStyle(color: textColor), // Non-const TextStyle
                ),
                onTap: () async {
                  await Auth().signOut();
                  if (!mounted) {
                    return;
                  }
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const OpeningPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flashcardWidget(Flashcard flashcard, Color textColor) {
    return Dismissible(
      key: Key(flashcard.id), // Unique key for each item
      background: Container(
        color: Colors.red, // Background color when swiping
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            final loc = AppLocalizations.of(context)!;
            const primaryColor = Color(0xFF2E3856); // Card color
            const textColor = Color(0xFFF6F7FB); // Text color

            return AlertDialog(
              backgroundColor: primaryColor, // Dialog color
              title: Text(
                loc.confirmDelete,
                style: const TextStyle(color: textColor), // Non-const TextStyle
              ),
              content: Text(
                loc.areYouSure,
                style: const TextStyle(color: textColor), // Non-const TextStyle
              ),
              actions: [
                TextButton(
                  child: Text(
                    loc.cancel,
                    style: const TextStyle(
                        color: textColor), // Non-const TextStyle
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Dismiss dialog
                  },
                ),
                TextButton(
                  child: Text(
                    loc.delete,
                    style: const TextStyle(
                        color: textColor), // Non-const TextStyle
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Dismiss dialog with result true
                  },
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        _deleteFlashcard(flashcard); // Call delete function if confirmed
      },
      child: ListTile(
        title: Text(
          flashcard.question,
          style: TextStyle(color: textColor),
        ),
        subtitle: _answerVisibility[flashcard.id] ?? false
            ? Text(
                flashcard.answer,
                style: TextStyle(color: textColor),
              )
            : null,
        onTap: () {
          setState(() {
            _answerVisibility[flashcard.id] =
                !(_answerVisibility[flashcard.id] ?? false);
          });
        },
      ),
    );
  }

  void _showDeleteConfirmation(Flashcard flashcard) {
    final loc = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF2E3856); // Card color
    const textColor = Color(0xFFF6F7FB); // Text color

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryColor, // Dialog color
          title: Text(
            loc.confirmDelete,
            style: const TextStyle(color: textColor), // Non-const TextStyle
          ),
          content: Text(
            loc.areYouSure,
            style: const TextStyle(color: textColor), // Non-const TextStyle
          ),
          actions: [
            TextButton(
              child: Text(
                loc.cancel,
                style:
                    const TextStyle(color: textColor), // Non-const TextButton
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
            TextButton(
              child: Text(
                loc.delete,
                style:
                    const TextStyle(color: textColor), // Non-const TextButton
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
                _deleteFlashcard(flashcard); // Perform deletion
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteFlashcard(Flashcard flashcard) async {
    await _flashcardController.removeFlashcard(flashcard);
    setState(() {
      _flashcards.removeWhere((t) => t.id == flashcard.id);
    });

    final loc = AppLocalizations.of(context)!;
    final snackBar = SnackBar(
      content: Text(loc.flashcardDeleted),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
