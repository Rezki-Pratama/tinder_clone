import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  //instance
  UserRepository({FirebaseAuth firebaseAuth, FirebaseFirestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  //fungsi login
  Future<void> signInWithEmail(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // check jika pertama kali login
  Future<bool> isFirstTime(String userId) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((user) => user.exists);
  }

  //daftar akun
  Future<void> signUpWithEmail(String email, String password) async {
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
    final currentUser = _firebaseAuth.currentUser;
    return currentUser.uid;
  }

  //profile setup
  Future<void> profileSetup(
      File photo,
      String userId,
      String name,
      String gender,
      String interestedIn,
      DateTime age,
      GeoPoint location) async {
    UploadTask uploadTask;
    uploadTask = FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(userId)
        .child(userId)
        .putFile(photo);

    //ketika berhasil upload file , mendapatkan url photo untuk disimpan di firestore dengan data yang lain
    return await (await uploadTask).ref.getDownloadURL().then((url) async {
      await _firestore.collection('users').doc(userId).set({
        'uid': userId,
        'photoUrl': url,
        'name': name,
        "location": location,
        'gender': gender,
        'interestedIn': interestedIn,
        'age': age
      });
    });
  }
}
