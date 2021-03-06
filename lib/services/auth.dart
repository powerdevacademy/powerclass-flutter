import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get user {
    return _auth.authStateChanges();
  }

  Future<User> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print("Erro sign in anonimo: ${e.toString()}");
      return null;
    }
  }

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print("Erro sign out: ${e.toString()}");
      return null;
    }
  }

  Future<User> signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Erro sign in com senha: ${e.toString()}");
      return null;
    }
  }

  Future<User> signUpWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Erro sign in com senha: ${e.toString()}");
      return null;
    }
  }

}