import '../model/flashcard.dart';

abstract class Storage {
  Stream<List<Flashcard>> getFlashcards();
  Future<void> insertFlashcard(Flashcard flashcard);
  Future<void> removeFlashcard(Flashcard flashcard);
  Future<void> initialize();
}
