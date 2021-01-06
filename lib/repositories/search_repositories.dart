import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder/model/user.dart';

class SearchRepository {
  final FirebaseFirestore _firestore;

  //instance
  SearchRepository({FirebaseFirestore firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<User> selectUser(currentUserId, selectedUserId, name, photoUrl) async {
    await _firestore.collection('users')
    .doc(currentUserId)
    .collection('selectList')
    .doc(selectedUserId)
    .set({});
    
    await _firestore.collection('users')
    .doc(selectedUserId)
    .collection('selectList')
    .doc(currentUserId)
    .set({});

    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('selectedList')
        .doc(currentUserId)
        .set({
      'name': name,
      'photoUrl': photoUrl,
    });
    return getUser(currentUserId);

  }

  Future passUser(currentUserId, selectedUserId) async {
    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('selectedList')
        .doc(currentUserId)
        .set({});

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('selectedList')
        .doc(selectedUserId)
        .set({});
    return getUser(currentUserId);
  }

  Future getUserInterests(userId) async {
    User currentUser = User();

    _firestore.collection('users').doc(userId).get().then((user) {
      currentUser.name = user['name'];
      currentUser.photo = user['photoUrl'];
      currentUser.gender = user['gender'];
      currentUser.interestedIn = user['interestedIn'];
    });
    return currentUser;
  }

  Future<List> getSelectedList(userId) async {
    List<String> selectedList = [];
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('selectedList')
        .get()
        .then((docs) {
      for (var doc in docs.docs) {
        if (docs.docs != null) {
          selectedList.add(doc.id);
        }
      }
    });
    return selectedList;
  }

  Future<User> getUser(userId) async {
    User _user = User();
    List<String> selectedList = await getSelectedList(userId);
    User currentUser = await getUserInterests(userId);

    await _firestore.collection('users').get().then((users) {
      for (var user in users.docs) {
        if ((!selectedList.contains(user.id)) &&
            (user.id != userId) &&
            (currentUser.interestedIn == user['gender']) &&
            (user['interestedIn'] == currentUser.gender)) {
          _user.uid = user.id;
          _user.name = user['name'];
          _user.photo = user['photoUrl'];
          _user.age = user['age'];
          _user.location = user['location'];
          _user.gender = user['gender'];
          _user.interestedIn = user['interestedIn'];
          break;
        }
      }
    });

    return _user;
  }

}
