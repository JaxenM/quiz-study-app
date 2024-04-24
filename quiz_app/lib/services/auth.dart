import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get stream => _auth.authStateChanges().asBroadcastStream();

  Future<String?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Sign-in successful, no error message needed
    } on FirebaseAuthException catch (e) {
      return _parseSignInAuthException(
          e); // Return an error message based on the exception
    }
  }

  Future<String?> createAccountWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null; // Indicate success explicitly
    } on FirebaseAuthException catch (e) {
      return _parseCreateAccountAuthException(e);
    }
  }

  // Implementing the userId getter to return the current user's ID
  String? get userId {
    return _auth.currentUser?.uid;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _parseSignInAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'Email address is not formatted correctly';
      case 'user-not-found':
      case 'wrong-password':
      case 'user-disabled':
        return 'Invalid username or password';
      case 'network-request-failed':
        return 'Please ensure you are online and try again';
      case 'too-many-requests':
      case 'operation-not-allowed':
      default:
        return 'An unknown error occurred';
    }
  }

  String _parseCreateAccountAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Email address is not formatted correctly';
      case 'email-already-in-use':
        return 'This email address already exists';
      case 'network-request-failed':
        return 'Please ensure you are online and try again';
      default:
        return 'An unknown error occurred';
    }
  }
}
