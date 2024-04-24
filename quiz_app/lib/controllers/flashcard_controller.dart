import '../model/flashcard.dart';
import '../services/firestore_storage.dart';
import '../services/storage.dart';

class FlashcardController {
  factory FlashcardController() => _singleton;

  FlashcardController._internal();

  static final FlashcardController _singleton = FlashcardController._internal();

  // Change to FirestoreBackend
  final Storage _storage = FirestoreStorage();

  Stream<List<Flashcard>> getStream() => _storage.getFlashcards();

  Future<void> insertFlashcard(Flashcard flashcard) async {
    await _storage.insertFlashcard(flashcard);
  }

  Future<void> removeFlashcard(Flashcard flashcard) async {
    await _storage.removeFlashcard(flashcard);
  }

  Future<void> initialize() async {
    await _storage.initialize();
  }
}