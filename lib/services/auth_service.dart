import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Signup function
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // null matlab koi error nahi, sab theek
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        return "Email already registered";
      } else {
        return e.message;
      }
    }
  }

  // Login function
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No account found with this email";
      } else if (e.code == 'wrong-password') {
        return "Incorrect password";
      } else if (e.code == 'invalid-credential') {
        return "Invalid email or password";
      } else {
        return e.message;
      }
    }
  }

  // Logout function
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Current logged-in user check karna
  User? get currentUser => _auth.currentUser;
}