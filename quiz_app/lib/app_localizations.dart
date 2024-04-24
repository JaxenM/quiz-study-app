import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Flashcards',
      'question': 'Question',
      'answer': 'Answer',
      'startQuiz': 'Start Quiz',
      'noFlashcardsAvailable': 'No flashcards available',
    },
    'es': {
      'title': 'Tarjetas',
      'question': 'Pregunta',
      'answer': 'Respuesta',
      'startQuiz': 'Iniciar cuestionario',
      'noFlashcardsAvailable': 'No hay tarjetas disponibles',
    },
    'fr': {
      'title': 'Cartes',
      'question': 'Question',
      'answer': 'Réponse',
      'startQuiz': 'Commencer le quiz',
      'noFlashcardsAvailable': 'Pas de cartes disponibles',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]!['title']!;
  }
}