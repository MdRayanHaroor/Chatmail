import 'package:cloud_firestore/cloud_firestore.dart';

// Message model
class Message {
  final String senderId;
  final String text;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}

// Service for sending and receiving messages
class MessageService {
  final CollectionReference messagesCollection = FirebaseFirestore.instance.collection('messages');

  Future<void> sendMessage(String senderId, String text) async {
    await messagesCollection.add({
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Send FCM notification to recipients (Add this part later)
    sendFCMNotification();
  }

  Stream<List<Message>> getMessages() {
    return messagesCollection.orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Message(
          senderId: data['senderId'],
          text: data['text'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  void sendFCMNotification() {
    // Implement FCM notification sending logic here
    // Use FirebaseMessaging to send a notification (Add this part later)
  }
}
