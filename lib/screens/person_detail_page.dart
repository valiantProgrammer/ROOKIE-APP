import 'package:flutter/material.dart';
import 'models/person_model.dart';

class PersonDetailPage extends StatelessWidget {
  final RegisteredPerson person;

  const PersonDetailPage({super.key, required this.person});

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
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 HEADER
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, color: primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Person Details",
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

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 🔥 PROFILE CARD
                        _card(
                          isDark,
                          child: Column(
                            children: [
                              // Profile Avatar
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white54,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Name
                              Text(
                                person.name,
                                style: TextStyle(
                                  color: primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // ID
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.badge, size: 14, color: secondary),
                                  const SizedBox(width: 6),
                                  Text(
                                    "ID: ${person.id}",
                                    style: TextStyle(
                                      color: secondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      person.status,
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 🔥 REGISTRATION INFO CARD
                        _card(
                          isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _title("Registration Information", Icons.info),
                              const SizedBox(height: 12),
                              _infoRow(
                                "Registered On:",
                                person.registrationDate,
                                secondary,
                              ),
                              const SizedBox(height: 8),
                              _infoRow("Status:", person.status, secondary),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 🔥 CAPTURED FACES CARD
                        _card(
                          isDark,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _title("Captured Face Images", Icons.camera_alt),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _faceImageBox(
                                    "Front Profile",
                                    person.capturedFaces["Front Profile"] ??
                                        false,
                                  ),
                                  _faceImageBox(
                                    "Left Profile",
                                    person.capturedFaces["Left Profile"] ??
                                        false,
                                  ),
                                  _faceImageBox(
                                    "Right Profile",
                                    person.capturedFaces["Right Profile"] ??
                                        false,
                                  ),
                                ],
                              ),
                            ],
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
      ),
    );
  }

  // 🔥 INFO ROW
  Widget _infoRow(String label, String value, Color secondary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: secondary, fontSize: 12)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // 🔥 FACE IMAGE BOX
  Widget _faceImageBox(String title, bool isCaptured) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isCaptured ? Colors.green.shade700 : Colors.black26,
            border: Border.all(
              color: isCaptured ? Colors.green.shade400 : Colors.white24,
              width: 2,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCaptured ? Icons.check_circle : Icons.person,
                  color: isCaptured ? Colors.white : Colors.white54,
                  size: isCaptured ? 28 : 32,
                ),
                if (isCaptured)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "Captured",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // 🔥 CARD
  Widget _card(bool isDark, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]
              : [Colors.white, Colors.grey.shade100],
        ),
      ),
      child: child,
    );
  }

  // 🔥 TITLE
  Widget _title(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 18),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
