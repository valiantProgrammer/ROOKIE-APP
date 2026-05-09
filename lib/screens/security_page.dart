import 'package:flutter/material.dart';

class SecurityPage extends StatefulWidget {
  final VoidCallback onBack;

  const SecurityPage({super.key, required this.onBack});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool twoFactor = true;
  bool loginAlerts = true;

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
                  "Security",
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
                // 🔐 SECURITY SETTINGS TITLE
                const Text(
                  "Security Settings",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 SETTINGS CARD
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _switchTile(
                        icon: Icons.verified_user,
                        title: "Two-Factor Authentication",
                        subtitle: "Add an extra layer of security",
                        value: twoFactor,
                        onChanged: (val) {
                          setState(() => twoFactor = val);
                        },
                        textColor: textColor,
                      ),
                      _divider(),

                      _switchTile(
                        icon: Icons.notifications,
                        title: "Login Alerts",
                        subtitle: "Get notified about new logins",
                        value: loginAlerts,
                        onChanged: (val) {
                          setState(() => loginAlerts = val);
                        },
                        textColor: textColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔐 ACTIONS TITLE
                const Text(
                  "Security Actions",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 ACTION CARD
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _actionTile(
                        icon: Icons.lock,
                        title: "Change Password",
                        subtitle: "Update your account password",
                        textColor: textColor,
                      ),
                      _divider(),
                      _actionTile(
                        icon: Icons.devices,
                        title: "Manage Devices",
                        subtitle: "View and manage your devices",
                        textColor: textColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 🔥 DECORATIVE ICON
                Icon(
                  Icons.security,
                  size: 120,
                  color: Colors.deepPurple.withValues(alpha: 0.15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 SWITCH TILE
  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color? textColor,
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
      trailing: Switch(
        value: value,
        activeColor: Colors.deepPurple,
        onChanged: onChanged,
      ),
    );
  }

  // 🔥 ACTION TILE
  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color? textColor,
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
    );
  }

  Widget _divider() =>
      Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2));
}
