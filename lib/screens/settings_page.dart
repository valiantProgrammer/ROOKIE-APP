import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(ThemeMode) onThemeChange;
  final Function(int) onNavigate;

  const SettingsPage({
    super.key,
    required this.onThemeChange,
    required this.onNavigate,
  });
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          children: [
            // 🔥 TOP HEADER

            // 🔥 BODY (IMPORTANT FIX HERE)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _profileCard(),
                  const SizedBox(height: 20),

                  _sectionTitle("Account"),
                  _card([
                    _item(
                      Icons.person,
                      "Personal Information",
                      "Update your name, email and profile",
                      onTap: () {
                        widget.onNavigate(7); // 🔥 go to PersonalInfoPage
                      },
                    ),
                    _divider(),
                    _item(
                      Icons.lock,
                      "Security",
                      "Change password and manage security",
                      onTap: () {
                        widget.onNavigate(8); // 🔥 go to PersonalInfoPage
                      },
                    ),
                    _divider(),
                    _item(
                      Icons.shield,
                      "Privacy",
                      "Manage your privacy settings",
                      onTap: () {
                        widget.onNavigate(9); // 🔥 go to PersonalInfoPage
                      },
                    ),
                  ]),

                  const SizedBox(height: 20),

                  _sectionTitle("Preferences"),
                  _card([
                    _item(
                      Icons.notifications,
                      "Notifications",
                      "Manage notification preferences",
                      onTap: () {
                        widget.onNavigate(10); // 🔥 go to PersonalInfoPage
                      },
                    ),
                    _divider(),
                    _item(
                      Icons.dark_mode,
                      "Appearance",
                      "Choose light or dark theme",
                      onTap: _showThemeSheet,
                    ),
                    _divider(),
                    _item(
                      Icons.language,
                      "Language",
                      "Select your preferred language",
                      onTap: () {
                        widget.onNavigate(11); // 🔥 go to PersonalInfoPage
                      },
                    ),
                  ]),

                  const SizedBox(height: 20),

                  _sectionTitle("App Settings"),
                  _card([
                    _item(
                      Icons.settings,
                      "General",
                      "General app settings and preferences",
                      onTap: () {
                        widget.onNavigate(12); // 🔥 go to PersonalInfoPage
                      },
                    ),
                    _divider(),
                    _item(
                      Icons.storage,
                      "Data & Storage",
                      "Manage your data and storage",
                      onTap: () {
                        widget.onNavigate(13); // 🔥 go to PersonalInfoPage
                      },
                    ),
                    _divider(),
                    _item(
                      Icons.info,
                      "About",
                      "App information and version",
                      onTap: () {
                        widget.onNavigate(14); // 🔥 go to PersonalInfoPage
                      },
                    ),
                  ]),

                  const SizedBox(height: 20),
                  _logoutCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 PROFILE CARD
  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "John Doe",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("john.doe@email.com"),
                SizedBox(height: 6),
                Chip(label: Text("Admin")),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  // 🔥 SECTION TITLE
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.deepPurple,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 🔥 CARD WRAPPER
  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.withValues(alpha: 0.1),
      ),
      child: Column(children: children),
    );
  }

  // 🔥 ITEM
  Widget _item(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
        child: Icon(icon, color: Colors.deepPurple),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _divider() =>
      Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2));

  // 🔥 LOGOUT
  Widget _logoutCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: const [
          Icon(Icons.logout, color: Colors.red),
          SizedBox(width: 12),
          Expanded(
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
          Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  // 🔥 THEME SWITCH
  void _showThemeSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Light Theme"),
            onTap: () {
              widget.onThemeChange(ThemeMode.light);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Dark Theme"),
            onTap: () {
              widget.onThemeChange(ThemeMode.dark);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
