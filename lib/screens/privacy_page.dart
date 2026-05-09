import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  final VoidCallback onBack;

  const PrivacyPage({super.key, required this.onBack});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool privateAccount = false;
  bool activityStatus = true;
  bool dataCollection = true;
  bool ads = false;

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
                  "Privacy",
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
                // 🔒 TITLE
                const Text(
                  "Privacy Settings",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 MAIN CARD
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _switchTile(
                        Icons.lock,
                        "Private Account",
                        "Only approved users can see your content",
                        privateAccount,
                        (v) => setState(() => privateAccount = v),
                        textColor,
                      ),
                      _divider(),

                      _switchTile(
                        Icons.people,
                        "Share Activity Status",
                        "Let others see when you're active",
                        activityStatus,
                        (v) => setState(() => activityStatus = v),
                        textColor,
                      ),
                      _divider(),

                      _switchTile(
                        Icons.visibility,
                        "Allow Data Collection",
                        "Help us improve your experience",
                        dataCollection,
                        (v) => setState(() => dataCollection = v),
                        textColor,
                      ),
                      _divider(),

                      _switchTile(
                        Icons.ad_units,
                        "Personalized Ads",
                        "Show ads relevant to you",
                        ads,
                        (v) => setState(() => ads = v),
                        textColor,
                      ),
                      _divider(),

                      _actionTile(
                        Icons.download,
                        "Download My Data",
                        "Get a copy of your data",
                        textColor,
                      ),
                    ],
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
                      Icon(Icons.shield, color: Colors.deepPurple),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "We take your privacy seriously. Your data is safe with us.",
                          style: TextStyle(
                            color: textColor!.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔁 SWITCH TILE
  Widget _switchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    Color? textColor,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
        child: Icon(icon, color: Colors.deepPurple),
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: textColor!.withValues(alpha: 0.6)),
      ),
      trailing: Switch(
        value: value,
        activeColor: Colors.deepPurple,
        onChanged: onChanged,
      ),
    );
  }

  // 👉 ACTION TILE
  Widget _actionTile(
    IconData icon,
    String title,
    String subtitle,
    Color? textColor,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
        child: Icon(icon, color: Colors.deepPurple),
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: textColor!.withValues(alpha: 0.6)),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  Widget _divider() =>
      Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2));
}
