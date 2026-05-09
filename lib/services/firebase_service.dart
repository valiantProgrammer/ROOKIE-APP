import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class FirebaseService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // =====================================================
  // INITIALIZE FIREBASE
  // =====================================================

  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      print('✅ Firebase initialized successfully');

      // Request notification permissions (iOS)
      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('✅ Notification permissions requested');
    } catch (e) {
      print('❌ Firebase initialization error: $e');
    }
  }

  // =====================================================
  // GET DEVICE TOKEN
  // =====================================================

  static Future<String?> getDeviceToken() async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        print('📱 Device Token: $token');
        // Save token locally for later use
        await ApiService.saveFCMToken(token);
      }
      return token;
    } catch (e) {
      print('❌ Error getting device token: $e');
      return null;
    }
  }

  // =====================================================
  // SEND TOKEN TO SERVER
  // =====================================================

  static Future<bool> sendTokenToServer(String token, String serverUrl) async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/register-device'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Token sent to server successfully');
        return true;
      } else {
        print('❌ Failed to send token: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending token to server: $e');
      return false;
    }
  }

  // =====================================================
  // LISTEN FOR FOREGROUND NOTIFICATIONS
  // =====================================================

  static void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('\n🔔 FOREGROUND MESSAGE RECEIVED');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');

      if (message.data.isNotEmpty) {
        handleNotificationData(message.data);
      }
    });
  }

  // =====================================================
  // LISTEN FOR BACKGROUND MESSAGES (when app closed)
  // =====================================================

  static Future<void> setupBackgroundMessageHandler() async {
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }

  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print('\n🔔 BACKGROUND MESSAGE RECEIVED');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');

    if (message.data.isNotEmpty) {
      handleNotificationData(message.data);
    }
  }

  // =====================================================
  // LISTEN FOR TERMINATED MESSAGES (app opened from notification)
  // =====================================================

  static Future<void> listenTerminatedMessages() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('\n🔔 TERMINATED MESSAGE RECEIVED');
      print('Title: ${initialMessage.notification?.title}');
      print('Body: ${initialMessage.notification?.body}');
      print('Data: ${initialMessage.data}');

      if (initialMessage.data.isNotEmpty) {
        handleNotificationData(initialMessage.data);
      }
    }
  }

  // =====================================================
  // HANDLE NOTIFICATION DATA
  // =====================================================

  static void handleNotificationData(Map<String, dynamic> data) {
    String type = data['type'] ?? 'unknown';

    switch (type) {
      case 'theft':
        print('🚨 THEFT ALERT RECEIVED');
        print('Camera: ${data['camera']}');
        break;
      case 'fire':
        print('🔥 FIRE ALERT RECEIVED');
        print('Camera: ${data['camera']}');
        break;
      default:
        print('📢 Generic notification: $data');
    }
  }

  // =====================================================
  // SUBSCRIBE TO TOPIC
  // =====================================================

  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('❌ Error subscribing to topic: $e');
    }
  }

  // =====================================================
  // UNSUBSCRIBE FROM TOPIC
  // =====================================================

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ Error unsubscribing from topic: $e');
    }
  }
}
