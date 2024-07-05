import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timestamp,
  });

  // Convert message object to a map
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderID: map['senderID'],
      senderEmail: map['senderEmail'],
      receiverID: map['receiverID'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().asyncMap((snapshot) async {
      List<Map<String, dynamic>> userList = [];
      for (var doc in snapshot.docs) {
        final user = doc.data() as Map<String, dynamic>;
        final lastMessage = await getLastMessage(user['uid']);
        user['lastMessageTimestamp'] = lastMessage?.timestamp ?? Timestamp(0, 0);
        userList.add(user);
      }
      userList.sort((a, b) => b['lastMessageTimestamp'].compareTo(a['lastMessageTimestamp']));
      return userList;
    });
  }

  Stream<List<Message>> getMessagesStream() {
    final currentUserID = _auth.currentUser!.uid;
    return _firestore
        .collectionGroup("messages")
        .where("receiverID", isEqualTo: currentUserID)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList());
  }

  Future<Message?> getLastMessage(String userID) async {
    final currentUserID = _auth.currentUser!.uid;
    final chatRoomID = [currentUserID, userID].toList()..sort();
    final snapshot = await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID.join('_'))
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();
    final messages = snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
    return messages.isNotEmpty ? messages.first : null;
  }

  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
