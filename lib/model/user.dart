import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid, name, gender, interestedIn, photo;
  Timestamp age;
  GeoPoint location;

  User(
      {this.uid,
      this.name,
      this.gender,
      this.interestedIn,
      this.photo,
      this.age});
}
