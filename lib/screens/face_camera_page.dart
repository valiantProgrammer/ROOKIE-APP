import 'package:flutter/material.dart';

class FaceCameraPage extends StatefulWidget {
  final String profileType; // "Front Profile", "Left Profile", "Right Profile"
  final VoidCallback onCaptured;

  const FaceCameraPage({
    super.key,
    required this.profileType,
    required this.onCaptured,
  });

  @override
  State<FaceCameraPage> createState() => _FaceCameraPageState();
}

class _FaceCameraPageState extends State<FaceCameraPage> {
  bool _imageCaptured = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.textTheme.bodyLarge!.color!;
    final secondary = theme.textTheme.bodyMedium!.color!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF05080F),
                    const Color(0xFF0A0F1C),
                    const Color(0xFF111827),
                  ]
                : [Colors.grey.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔙 HEADER
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, color: primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Capture ${widget.profileType}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),

              // 🔥 CAMERA VIEW
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: [
                      // Camera Preview Box
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _imageCaptured
                                  ? Colors.green.shade400
                                  : secondary.withOpacity(0.3),
                              width: 2,
                            ),
                            color: Colors.black,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Camera placeholder
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.black87,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 64,
                                      color: Colors.white38,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _imageCaptured
                                          ? "✓ ${widget.profileType} Captured"
                                          : "Position your face for ${widget.profileType}",
                                      style: TextStyle(
                                        color: _imageCaptured
                                            ? Colors.green.shade400
                                            : Colors.white54,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              // Guidance overlay
                              if (!_imageCaptured)
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple.withOpacity(
                                          0.7,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _getGuidanceText(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    // Face frame guide
                                    Container(
                                      width: 120,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                          color: Colors.deepPurple.withOpacity(
                                            0.5,
                                          ),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Capture Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _imageCaptured = true;
                          });
                          Future.delayed(const Duration(seconds: 1), () {
                            widget.onCaptured();
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            _imageCaptured ? Icons.check : Icons.camera,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGuidanceText() {
    switch (widget.profileType) {
      case "Front Profile":
        return "Face the camera directly\nKeep eyes looking forward";
      case "Left Profile":
        return "Turn your head to the left\nShow your left side clearly";
      case "Right Profile":
        return "Turn your head to the right\nShow your right side clearly";
      default:
        return "Position your face and tap to capture";
    }
  }
}
