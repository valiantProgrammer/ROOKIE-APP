import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  final VoidCallback onBack;

  const LanguagePage({super.key, required this.onBack});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selected = "English";

  final List<Map<String, String>> languages = [
    {"name": "English", "sub": "English"},
    {"name": "हिंदी", "sub": "Hindi"},
    {"name": "বাংলা", "sub": "Bengali"},
    {"name": "ગુજરાતી", "sub": "Gujarati"},
    {"name": "தமிழ்", "sub": "Tamil"},
    {"name": "తెలుగు", "sub": "Telugu"},
    {"name": "मराठी", "sub": "Marathi"},
  ];

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Container(
      color: bgColor,
      child: Column(
        children: [
          // 🔥 HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5F2EEA), Color(0xFF7C4DFF)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onBack,
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Language",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 🔤 TITLE
                const Text(
                  "Select Language",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 LANGUAGE CARD
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: List.generate(languages.length, (i) {
                      final lang = languages[i];
                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple.withValues(
                                alpha: 0.1,
                              ),
                              child: const Icon(
                                Icons.language,
                                color: Colors.deepPurple,
                              ),
                            ),
                            title: Text(
                              lang["name"]!,
                              style: TextStyle(color: textColor),
                            ),
                            subtitle: Text(
                              lang["sub"]!,
                              style: TextStyle(
                                color: textColor!.withValues(alpha: 0.6),
                              ),
                            ),
                            trailing: Radio<String>(
                              value: lang["name"]!,
                              groupValue: selected,
                              activeColor: Colors.deepPurple,
                              onChanged: (val) {
                                setState(() {
                                  selected = val!;
                                });
                              },
                            ),
                          ),
                          if (i != languages.length - 1)
                            Divider(
                              height: 1,
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                        ],
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔥 INFO BOX
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.deepPurple.withValues(alpha: 0.1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.language, color: Colors.deepPurple),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "The app will restart to apply the selected language.",
                          style: TextStyle(
                            color: textColor!.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 🔥 DECORATIVE ICON
                Icon(
                  Icons.translate,
                  size: 120,
                  color: Colors.deepPurple.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
