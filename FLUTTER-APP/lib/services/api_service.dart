import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart'; 

class ApiService {
  // ⚠️ Ensure this is your current Wi-Fi IPv4 address!
  static const String baseUrl = 'http://192.168.1.165:5000/api';

  // Store the JWT Token locally
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }
  
  // Retrieve the Token (useful for routing later)
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Clear the Token on Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    try { await GoogleSignIn.instance.signOut(); } catch (e) { print(e); }
  }

  // =====================================================
  // FCM DEVICE TOKEN STORAGE
  // =====================================================
  
  // Store FCM Device Token locally
  static Future<void> saveFCMToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
    print('💾 FCM Token saved locally');
  }
  
  // Retrieve FCM Device Token
  static Future<String?> getFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await saveToken(data['token']); // Save the token!
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        await saveToken(data['token']); // Log them in automatically!
        print('✅ Registration successful!');
        return true;
      }
      print('❌ Registration failed: ${response.body}');
      return false;
    } catch (e) {
      print('❌ Error registering: $e');
      return false;
    }
  }

  // 🔥 COMPLETELY UPGRADED FOR GOOGLE SIGN-IN V7.0+
  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      
      // 1. Mandatory Initialization Step
      await googleSignIn.initialize(
        clientId: 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com', 
      );
      
      // 2. Authenticate replaces the old 'signIn' method
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      // 3. Fetch ID Token (This is now SYNCHRONOUS, no 'await' needed!)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) throw Exception("Failed to extract ID token.");

      // 4. Send the Google Token to your Node.js backend
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idToken': idToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        await saveToken(data['token']);
        return true;
      }
      return false;
    } catch (e) {
      print("Google Sign In Error: $e");
      // Note: Canceled sign-ins automatically throw an error in V7, so it will safely land here and return false.
      return false; 
    }
  }

  static Future<List<dynamic>> getDevices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/devices'));
      if (response.statusCode == 200) {
        return json.decode(response.body);  
      } else {
        throw Exception('Failed to load devices');
      }
    } catch (e) {
      print('Error fetching devices: $e');
      return [];
    }
  }

  static Future<bool> registerPerson(String fullName, String employeeId, List<File> imageFiles) async {
    try {
      var uri = Uri.parse('$baseUrl/people/register');
      var request = http.MultipartRequest('POST', uri);

      request.fields['fullName'] = fullName;
      request.fields['employeeId'] = employeeId;

      for (var file in imageFiles) {
        var multipartFile = await http.MultipartFile.fromPath('images', file.path);
        request.files.add(multipartFile);
      }

      print('📤 Sending ${imageFiles.length} images to server...');
      var response = await request.send();

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Successfully registered face!');
        return true;
      } else {
        print('❌ Failed to register. Server responded with: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending registration data: $e');
      return false;
    }
  }

  static Future<bool> uploadMedia(File file, String type, String cameraName) async {
    try {
      var uri = Uri.parse('$baseUrl/media/upload');
      var request = http.MultipartRequest('POST', uri);

      request.fields['type'] = type;
      request.fields['cameraName'] = cameraName;

      var multipartFile = await http.MultipartFile.fromPath('mediaFile', file.path);
      request.files.add(multipartFile);

      print('📤 Uploading $type to server...');
      
      var response = await request.send().timeout(const Duration(seconds: 15));

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Successfully uploaded $type!');
        return true;
      } else {
        print('❌ Failed to upload. Server responded with: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error uploading media: $e');
      return false;
    }
  }
}