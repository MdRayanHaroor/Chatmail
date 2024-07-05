import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:chat_app/services/notification/fcm_service.dart'; // Import the FCM service
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import flutter_local_notifications


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    String? token = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $token');
  } catch (e) {
    print('Error getting FCM token: $e');
  }

  // Initialize flutter_local_notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  //await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        Provider(create: (context) => FCMService()), // Add the FCMService provider
      ],
      child:  MyApp(
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.flutterLocalNotificationsPlugin,
  }) : super(key: key);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  Widget build(BuildContext context) {
    // Access the FCMService instance
    final fcmService = Provider.of<FCMService>(context);

    // Initialize FCM
    fcmService.setupFCM();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
