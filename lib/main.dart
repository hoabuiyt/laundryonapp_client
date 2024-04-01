import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'dart:async';

import 'Screens/ClothSelectionScreen.dart';
import 'Screens/LaundryScreen.dart';
import 'Screens/DeliveryTypeScreen.dart';
import 'Screens/DateTimeScreen.dart';
import 'Screens/ClothSelectionScreen.dart';
import 'Screens/NewAddressScreen.dart';
import 'Screens/Auth/Login.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/LaundryOrderSummaryScreen.dart';
import 'Screens/Auth/SignUp_1.dart';
import 'Screens/Auth/SignUp_2.dart';
import 'Screens/Payments/stripe.dart';
import 'Screens/addressListScreen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Stripe.publishableKey =
      'pk_test_51OCeU2G8qLogHio9OFap0PagusWnHr30coiqvoUVMiCV4cNBJ16rzFoqbfDfNKRCAVjqZcDiD4DnAkMzHtX0ykds00pnqdrjLd';

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();
  print('User granted permission: ${settings.authorizationStatus}');

  String? token = await FirebaseMessaging.instance.getToken();
  print("Firebase Messaging Token: $token");

  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {}

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print("Token refreshed: $newToken");
  });

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LaundryonApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}

void sendTokenToServer(String? token) {
  print("Sending token to server: $token");
}
