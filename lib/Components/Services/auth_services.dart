import 'package:beirut/Components/Services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        // ignore: missing_return
        (FirebaseUser user) {
          user?.uid;
          user?.email;
        },
      );

  // GET UID
  Future<String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  //Create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    // print(user.email);
    return user != null
        ? User(
            uid: user.uid,
            email: user.email,
          )
        : null;
  }

  //auth change user Stream
  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //Sign in anonymously
  Future signInAnon() async {
    try {
      AuthResult result = await _firebaseAuth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Singin with mail & password
  Future<User> signInWithEmailAndPassword(
      String _email, String _password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: _email, password: _password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

//Register User
  Future<User> registerWithEmailAndPassword(
      String _email, String _password, int _phone) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      print(_email);
      print(_password);
      print(_phone);
      return null;
    }
  }

  //SignOut
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Forgot Password
  Future resetPassword(String _email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: _email);
  }
}