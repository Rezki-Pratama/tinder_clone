import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  //instance
  UserRepository({FirebaseAuth firebaseAuth, FirebaseFirestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  //fungsi login
  Future<void> signInWithEmail(String email, String password) {
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  // check jika pertama kali login
  Future<bool> isFirstTime(String userId) async {
    bool exist;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((user) => {exist = user.exists});

    return exist;
  }

  //daftar akun
  Future<void> signUpWithEmail(String email, String password) async {
    print(_firebaseAuth);
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  //log out / keluar
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  //check jika sedang login
  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  //get uid
  Future<String> getUser() async {
    return _firebaseAuth.currentUser.uid;
  }

}
