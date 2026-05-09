import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;

  const AuthScreen({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitAuth() async {
    setState(() => isLoading = true);

    bool success = false;
    if (isLogin) {
      success = await ApiService.login(_emailController.text.trim(), _passwordController.text.trim());
    } else {
      success = await ApiService.register(_nameController.text.trim(), _emailController.text.trim(), _passwordController.text.trim());
    }

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen(onThemeChange: _dummyTheme, onNavigate: _dummyNav)));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Authentication Failed. Check credentials.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        )
      );
    }
  }

  void _googleAuth() async {
    setState(() => isLoading = true);
    bool success = await ApiService.signInWithGoogle();
    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen(onThemeChange: _dummyTheme, onNavigate: _dummyNav)));
    }
  }

  static void _dummyTheme(ThemeMode mode) {}
  static void _dummyNav(int index) {}

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Premium Dark Theme Colors
    const Color bgDark = Color(0xFF09090E); // Deepest almost-black
    const Color glowPurple = Color(0xFF651FFF);
    const Color glowPink = Color(0xFFD500F9);
    
    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          // 🔥 AMBIENT BACKGROUND GLOWS (Top Left)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: glowPurple.withOpacity(0.3),
              ),
            ),
          ),
          // 🔥 AMBIENT BACKGROUND GLOWS (Bottom Right)
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: glowPink.withOpacity(0.2),
              ),
            ),
          ),
          // 🔥 BLUR FILTER TO CREATE PREMIUM GLASS EFFECT
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),

          // 🔥 MAIN CONTENT
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO / BRANDING
                    const Icon(Icons.shield_moon_rounded, size: 70, color: Colors.white),
                    const SizedBox(height: 16),
                    const Text(
                      "ROOKIE",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "SURVEILLANCE PROTOCOL",
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 2,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // 🔥 FROSTED GLASS AUTH CARD
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 450),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isLogin ? "Access System" : "Initialize Agent",
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isLogin ? "Enter your credentials to continue." : "Register your credentials to the database.",
                                style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
                              ),
                              const SizedBox(height: 32),

                              // FORM FIELDS
                              if (!isLogin) ...[
                                _buildSleekField("Full Name", Icons.person_outline, _nameController),
                                const SizedBox(height: 16),
                              ],
                              _buildSleekField("Email Address", Icons.alternate_email, _emailController),
                              const SizedBox(height: 16),
                              _buildSleekField("Password", Icons.lock_outline, _passwordController, isPassword: true),
                              
                              if (isLogin) ...[
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("Forgot Password?", style: TextStyle(color: glowPurple, fontWeight: FontWeight.w600, fontSize: 13)),
                                ),
                              ],
                              const SizedBox(height: 32),

                              // 🔥 GLOWING GRADIENT ACTION BUTTON
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF7C4DFF), Color(0xFF651FFF)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF651FFF).withOpacity(0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  onPressed: isLoading ? null : _submitAuth,
                                  child: isLoading
                                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : Text(
                                          isLogin ? "AUTHORIZE" : "REGISTER",
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 16),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // DIVIDER
                              Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text("OR", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                  Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // 🔥 GOOGLE BUTTON
                              GestureDetector(
                                onTap: isLoading ? null : _googleAuth,
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.g_mobiledata, color: Colors.white, size: 30),
                                      const SizedBox(width: 8),
                                      Text("Continue with Google", style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600, fontSize: 15)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // TOGGLE LOGIN/SIGNUP
                              Center(
                                child: GestureDetector(
                                  onTap: () => setState(() => isLogin = !isLogin),
                                  child: RichText(
                                    text: TextSpan(
                                      text: isLogin ? "No access privileges? " : "Already registered? ",
                                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: isLogin ? "Request Access" : "Return to Login",
                                          style: const TextStyle(color: Color(0xFFB388FF), fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 CUSTOM SLEEK TEXT FIELD
  Widget _buildSleekField(String hint, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 15),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.5), size: 20),
          suffixIcon: isPassword ? Icon(Icons.visibility_off_outlined, color: Colors.white.withOpacity(0.3), size: 20) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }
}