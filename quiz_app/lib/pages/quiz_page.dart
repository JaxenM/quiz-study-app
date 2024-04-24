import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import '../model/flashcard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizPage extends StatefulWidget {
  final List<Flashcard> flashcards;

  const QuizPage({super.key, required this.flashcards});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  bool _isFront = true;
  late List<Flashcard> _currentFlashcards;
  late List<Flashcard> _originalOrder;

  @override
  void initState() {
    super.initState();
    _originalOrder = List.from(widget.flashcards); // Save original order
    _currentFlashcards = List.from(widget.flashcards); // Assign current list
  }

  void _shuffleFlashcards() {
    setState(() {
      final random = Random();
      _currentFlashcards.shuffle(random);
      _currentIndex = 0;
      _isFront = true;
    });
  }

  void _resetToOriginalOrder() {
    setState(() {
      _currentFlashcards = List.from(_originalOrder);
      _currentIndex = 0;
      _isFront = true;
    });
  }

  void _showEndOfQuizDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF2E3856); // Card color
    const textColor = Color(0xFFF6F7FB); // Text color

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryColor, // Dialog color same as card
          title: Text(
            loc.endOfQuizTitle,
            style: const TextStyle(color: textColor), // Same text color
          ),
          content: Text(
            loc.endOfQuizMessage,
            style: const TextStyle(color: textColor), // Same text color
          ),
          actions: [
            TextButton(
              onPressed: () {
                _resetToOriginalOrder(); // Reset and restart the quiz
                Navigator.pop(context); // Close the dialog
              },
              child: Text(loc.restart,
                  style: const TextStyle(
                      color: textColor)), // Restart button color
            ),
            TextButton(
              onPressed: () {
                _resetToOriginalOrder(); // Reset flashcards
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Navigate back to home
              },
              child: Text(loc.home,
                  style:
                      const TextStyle(color: textColor)), // Home button color
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF2E3856); // Card color
    const textColor = Color(0xFFF6F7FB); // Text color
    const disabledColor = Color(0xFFB0B3C1); // Light gray for disabled

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${loc.quiz} (${_currentIndex + 1}/${_currentFlashcards.length})"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle, color: textColor),
            onPressed: _shuffleFlashcards,
          ),
        ],
      ),
      body: _currentFlashcards.isNotEmpty
          ? Center(
              child: GestureDetector(
                onTap: () => setState(() => _isFront = !_isFront),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    final rotateAnim =
                        Tween(begin: pi, end: 0.0).animate(animation);
                    return AnimatedBuilder(
                      animation: rotateAnim,
                      child: child,
                      builder: (context, child) {
                        var angle = rotateAnim.value;
                        if (angle >= pi / 2) {
                          angle = pi - angle;
                        }
                        return Transform(
                          transform: Matrix4.rotationY(angle),
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                    );
                  },
                  child: _isFront
                      ? Card(
                          key: ValueKey<int>(_currentIndex),
                          color: primaryColor,
                          child: Container(
                            width: 300,
                            height: 300,
                            alignment: Alignment.center,
                            child: Text(
                              _currentFlashcards[_currentIndex].question,
                              style: const TextStyle(
                                fontSize: 24,
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Card(
                          key: ValueKey<int>(
                              _currentIndex + _currentFlashcards.length),
                          color: primaryColor,
                          child: Container(
                            width: 300,
                            height: 300,
                            alignment: Alignment.center,
                            child: Text(
                              _currentFlashcards[_currentIndex].answer,
                              style: const TextStyle(
                                fontSize: 24,
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
              ),
            )
          : Center(
              child: Text(
                loc.noFlashcardsAvailable,
                style: const TextStyle(
                  color: textColor,
                ),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        color: primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: _currentIndex > 0 ? textColor : disabledColor,
              onPressed: _currentIndex > 0
                  ? () => setState(() {
                        _currentIndex--;
                        _isFront = true;
                      })
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              color: _currentIndex < _currentFlashcards.length - 1
                  ? textColor
                  : disabledColor,
              onPressed: _currentIndex < _currentFlashcards.length - 1
                  ? () => setState(() {
                        _currentIndex++;
                        _isFront = true;
                      })
                  : () =>
                      _showEndOfQuizDialog(context), // Show dialog on last card
            ),
          ],
        ),
      ),
    );
  }
}
