import 'package:flutter/material.dart';

class GeneralPage extends StatefulWidget {
  final VoidCallback onBack;
  final Function(int) onNavigate;

  const GeneralPage({
    super.key,
    required this.onBack,
    required this.onNavigate,
  });

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  bool autoUpdate = true;
  bool backgroundSync = true;
  bool logs = false;

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
                  "General",
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
                // 🔥 TITLE
                const Text(
                  "General Settings",
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
                      _actionTile(
                        Icons.language,
                        "App Language",
                        "Select your preferred language",
                        textColor,
                        onTap: () => widget.onNavigate(11),
                      ),
                      _divider(),

                      _switchTile(
                        Icons.refresh,
                        "Auto Update",
                        "Keep the app updated automatically",
                        autoUpdate,
                        (v) => setState(() => autoUpdate = v),
                        textColor,
                      ),
                      _divider(),

                      _switchTile(
                        Icons.cloud_upload,
                        "Background Sync",
                        "Sync data in the background",
                        backgroundSync,
                        (v) => setState(() => backgroundSync = v),
                        textColor,
                      ),
                      _divider(),

                      _switchTile(
                        Icons.description,
                        "Enable Logs",
                        "Help us improve by sending logs",
                        logs,
                        (v) => setState(() => logs = v),
                        textColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔥 OTHER TITLE
                const Text(
                  "Other",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 OTHER CARD
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _valueTile(
                        Icons.notifications,
                        "Default Startup Page",
                        "Choose your default startup page",
                        "Home",
                        textColor,
                      ),
                      _divider(),

                      _valueTile(
                        Icons.delete,
                        "Clear Cache",
                        "Free up space by clearing app cache",
                        "256 MB",
                        textColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 🔥 DECORATIVE ICON
                Icon(
                  Icons.settings,
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
    Color? textColor, {
    VoidCallback? onTap,
  }) {
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
      onTap: onTap,
    );
  }

  // 👉 VALUE TILE (right text)
  Widget _valueTile(
    IconData icon,
    String title,
    String subtitle,
    String value,
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(color: textColor)),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2));
}
