import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart'; 
import 'services/websocket_service.dart';
import 'services/api_service.dart';
import 'services/firebase_service.dart';

void main() async {
  // 🔥 Required when doing async work (like fetching tokens) before runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🔥 Initialize Firebase
  await FirebaseService.initializeFirebase();
  
  // 🔥 Setup background message handler
  await FirebaseService.setupBackgroundMessageHandler();
  
  // Check if a user is already logged in
  String? token = await ApiService.getToken();

  runApp(RookieApp(initialToken: token));
}

class RookieApp extends StatefulWidget {
  // 🔥 THE FIX: We must explicitly declare the variable in the constructor!
  final String? initialToken;
  const RookieApp({super.key, this.initialToken});

  @override
  State<RookieApp> createState() => _RookieAppState();
}

class _RookieAppState extends State<RookieApp> {
  ThemeMode themeMode = ThemeMode.dark;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // 🔥 THE FIX: Use "widget.initialToken" to access it inside the State class
    if (widget.initialToken != null) {
      print('🚀 FLUTTER: App launched, attempting connection...');
      WebSocketService.connect();
      
      // 🔥 Setup FCM
      _setupFCM();
    }
  }

  // =====================================================
  // SETUP FCM
  // =====================================================
  
  void _setupFCM() async {
    // Listen for foreground messages
    FirebaseService.listenForegroundMessages();
    
    // Listen for terminated messages (app opened from notification)
    await FirebaseService.listenTerminatedMessages();
    
    // Get device token and send to server
    String? deviceToken = await FirebaseService.getDeviceToken();
    if (deviceToken != null) {
      // TODO: Replace with your actual server URL
      String serverUrl = 'http://192.168.1.10:8000';
      await FirebaseService.sendTokenToServer(deviceToken, serverUrl);
    }
  }

  void changeTheme(ThemeMode mode) {
    setState(() => themeMode = mode);
  }

  void navigate(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ROOKIE SYSTEM",
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      
      // 🔥 The Routing Brain: Show Home if token exists, else show Auth
      home: widget.initialToken != null 
          ? HomeScreen(onThemeChange: changeTheme, onNavigate: navigate)
          : AuthScreen(isDark: themeMode == ThemeMode.dark, onThemeToggle: () {
              changeTheme(themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
            }),
    );
  }
}