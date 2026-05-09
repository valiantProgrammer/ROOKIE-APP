import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  final VoidCallback onBack;

  const NotificationSettingsPage({super.key, required this.onBack});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool push = true;
  bool email = true;
  bool inApp = true;
  bool marketing = false;
  bool events = true;
  bool messages = true;
  bool dnd = false;

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
                  "Notifications",
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
                // 🔔 TITLE
                const Text(
                  "Manage Notifications",
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
                        Icons.notifications,
                        "Push Notifications",
                        "Receive push notifications",
                        push,
                        (v) => setState(() => push = v),
                        textColor,
                      ),
                      _divider(),
                      _switchTile(
                        Icons.email,
                        "Email Notifications",
                        "Receive email updates",
                        email,
                        (v) => setState(() => email = v),
                        textColor,
                      ),
                      _divider(),
                      _switchTile(
                        Icons.notifications_active,
                        "In-App Notifications",
                        "Show in-app alerts",
                        inApp,
                        (v) => setState(() => inApp = v),
                        textColor,
                      ),
                      _divider(),
                      _switchTile(
                        Icons.campaign,
                        "Marketing Updates",
                        "Receive offers and news",
                        marketing,
                        (v) => setState(() => marketing = v),
                        textColor,
                      ),
                      _divider(),
                      _switchTile(
                        Icons.event,
                        "Event Reminders",
                        "Get reminders about events",
                        events,
                        (v) => setState(() => events = v),
                        textColor,
                      ),
                      _divider(),
                      _switchTile(
                        Icons.message,
                        "Message Notifications",
                        "Notify for new messages",
                        messages,
                        (v) => setState(() => messages = v),
                        textColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🌙 QUIET HOURS TITLE
                const Text(
                  "Quiet Hours",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 QUIET HOURS CARD
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.nightlight,
                        color: Colors.deepPurple,
                      ),
                    ),
                    title: Text(
                      "Do Not Disturb",
                      style: TextStyle(color: textColor),
                    ),
                    subtitle: Text(
                      "Silence notifications during selected hours",
                      style: TextStyle(
                        color: textColor!.withValues(alpha: 0.6),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          value: dnd,
                          activeColor: Colors.deepPurple,
                          onChanged: (v) => setState(() => dnd = v),
                        ),
                        if (dnd)
                          const Text(
                            "10:00 PM – 7:00 AM",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.deepPurple,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // 🔥 DECORATIVE ICON
                Icon(
                  Icons.notifications,
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

  Widget _divider() =>
      Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2));
}
