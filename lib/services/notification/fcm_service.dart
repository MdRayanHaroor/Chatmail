// Import necessary packages
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Method to set up FCM
  Future<void> setupFCM() async {
    // Request permission for receiving notifications (iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Check if the user granted permission
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for notifications');

      // Get the FCM token
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      // Set up a listener for incoming messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Handle incoming messages (customize this part)
        print('Received notification: ${message.notification?.title}, ${message.notification?.body}');
      });
    } else {
      print('User declined permission for notifications');
    }
  }
}
