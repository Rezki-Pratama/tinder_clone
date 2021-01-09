
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tinder/model/message.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  String uuid = Uuid().v4();

  ChatRepository({FirebaseStorage firebaseStorage, FirebaseFirestore firestore})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future sendMessage({Message message}) async {
    UploadTask uploadTask;
    DocumentReference messageRef = _firestore.collection('messages').document();
    CollectionReference senderRef = _firestore
        .collection('users')
        .doc(message.senderId)
        .collection('chats')
        .doc(message.selectedUserId)
        .collection('messages');

    CollectionReference sendUserRef = _firestore
        .collection('users')
        .doc(message.selectedUserId)
        .collection('chats')
        .doc(message.senderId)
        .collection('messages');

    if (message.photo != null) {
      Reference photoRef = _firebaseStorage
          .ref()
          .child('messages')
          .child(messageRef.id)
          .child(uuid);

      uploadTask = photoRef.putFile(message.photo);

      return await (await uploadTask).ref.getDownloadURL().then((url) async {
          await messageRef.set({
            'senderName': message.senderName,
            'senderId': message.senderId,
            'text': null,
            'photoUrl': url,
            'timestamp': DateTime.now(),
          });
        });

      senderRef
          .doc(messageRef.id)
          .set({'timestamp': DateTime.now()});

      sendUserRef
          .doc(messageRef.id)
          .set({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.selectedUserId)
          .update({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('chats')
          .doc(message.senderId)
          .update({'timestamp': DateTime.now()});
    }
    if (message.text != null) {
      await messageRef.set({
        'senderName': message.senderName,
        'senderId': message.senderId,
        'text': message.text,
        'photoUrl': null,
        'timestamp': DateTime.now(),
      });

      senderRef
          .doc(messageRef.id)
          .set({'timestamp': DateTime.now()});

      sendUserRef
          .doc(messageRef.id)
          .set({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.selectedUserId)
          .update({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('chats')
          .doc(message.senderId)
          .update({'timestamp': DateTime.now()});
    }
  }

  Stream<QuerySnapshot> getMessages({currentUserId, selectedUserId}) {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<Message> getMessageDetail({messageId}) async {
    Message _message = Message();

    await _firestore
        .collection('messages')
        .doc(messageId)
        .get()
        .then((message) {
      _message.senderId = message['senderId'];
      _message.senderName = message['senderName'];
      _message.timestamp = message['timestamp'];
      _message.text = message['text'];
      _message.photoUrl = message['photoUrl'];
    });

    return _message;
  }
}