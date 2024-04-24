import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/flashcard.dart';
import 'storage.dart';

class FirestoreStorage implements Storage {
  static const _flashcardsCollection = 'flashcards';
  static const _usersCollection = 'users';
  static const _question = 'question';
  static const _answer = 'answer';

  // Helper method to get the current user's ID
  String? _getUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Stream<List<Flashcard>> getFlashcards() {
    final userId = _getUserId();
    if (userId == null) {
      return const Stream.empty(); // Return an empty stream if there's no user
    }
    return FirebaseFirestore.instance
        .collection('$_usersCollection/$userId/$_flashcardsCollection')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Flashcard(
                id: doc.id,
                question: data?[_question] ?? '',
                answer: data[_answer] ?? '',
              );
            }).toList());
  }

  @override
  Future<void> insertFlashcard(Flashcard flashcard) {
    final userId = _getUserId();
    if (userId == null) {
      return Future.error('No user signed in');
    }
    return FirebaseFirestore.instance
        .collection('$_usersCollection/$userId/$_flashcardsCollection')
        .add({
      _question: flashcard.question,
      _answer: flashcard.answer,
    });
  }

  @override
  Future<void> removeFlashcard(Flashcard flashcard) {
    final userId = _getUserId();
    if (userId == null) {
      return Future.error('No user signed in');
    }
    return FirebaseFirestore.instance
        .collection(
            '$_usersCollection/$userId/$_flashcardsCollection')
        .doc(flashcard.id)
        .delete();
  }

  @override
  Future<void> initialize() {
    // Implementation of initialize if needed
    return Future.value();
  }
}
