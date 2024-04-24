import 'package:uuid/uuid.dart';

class Flashcard {
  Flashcard({required this.question, required this.answer, String? id})
      : id = id ?? _uuid.v1();

  final String question;
  final String answer;
  static const _uuid = Uuid();
  final String id;
}
