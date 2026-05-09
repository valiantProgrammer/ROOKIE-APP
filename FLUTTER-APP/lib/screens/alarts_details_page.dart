import 'package:flutter/material.dart';

class AlertDetailsPage extends StatelessWidget {
  final String title;
  final String location;
  final String time;
  final String type;
  final Color typeColor;
  final String imageUrl;
  final IconData? icon;
  final String description;

  const AlertDetailsPage({
    super.key,
    required this.title,
    required this.location,
    required this.time,
    required this.type,
    required this.typeColor,
    required this.imageUrl,
    this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme-aware colors
    final primaryText = isDark ? Colors.white : Colors.black87;
    final secondaryText = isDark ? Colors.white70 : Colors.black54;

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, color: primaryText),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Alert Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(Icons.share, color: primaryText),
                  ],
                ),
                const SizedBox(height: 20),

                // Alert title & badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            typeColor.withOpacity(0.4),
                            typeColor.withOpacity(0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon ?? Icons.warning, color: typeColor),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: primaryText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      typeColor.withOpacity(0.4),
                                      typeColor.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    color: typeColor,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            time,
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 11,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 12,
                                color: secondaryText,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                location,
                                style: TextStyle(
                                  color: secondaryText,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Video preview with glowing play button
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.black.withOpacity(0.6),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Premium action buttons
                Row(
                  children: [
                    _actionBtn(Icons.download, "Download Clip", isDark),
                    _actionBtn(Icons.share, "Share", isDark),
                    _actionBtn(Icons.shield, "Report", isDark, highlight: true),
                  ],
                ),
                const SizedBox(height: 20),

                // Details section
                Text(
                  "Details",
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Glass card for details
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              Colors.white.withOpacity(0.05),
                              Colors.white.withOpacity(0.02),
                            ]
                          : [Colors.white, Colors.grey.shade100],
                    ),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.05),
                    ),
                  ),
                  child: Column(
                    children: [
                      _detail(
                        "Time of Activity",
                        time,
                        Icons.access_time,
                        isDark,
                        primaryText,
                        secondaryText,
                      ),
                      _detail(
                        "Place of Activity",
                        location,
                        Icons.location_on,
                        isDark,
                        primaryText,
                        secondaryText,
                      ),
                      _detail(
                        "Category",
                        type,
                        Icons.label,
                        isDark,
                        primaryText,
                        secondaryText,
                      ),
                      _detail(
                        "Duration",
                        "00:18 (18 seconds)",
                        Icons.timer,
                        isDark,
                        primaryText,
                        secondaryText,
                      ),
                      _detail(
                        "Device",
                        location,
                        Icons.devices,
                        isDark,
                        primaryText,
                        secondaryText,
                      ),
                      _detail(
                        "Description",
                        description,
                        Icons.description,
                        isDark,
                        primaryText,
                        secondaryText,
                      ),
                      _detail(
                        "Alert Type",
                        type,
                        Icons.timeline,
                        isDark,
                        primaryText,
                        secondaryText,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Related actions
                Text(
                  "Related Actions",
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                _actionTile("Add Notes", Icons.note, Colors.blue, isDark),
                _actionTile(
                  "Mark as Resolved",
                  Icons.check,
                  Colors.green,
                  isDark,
                ),
                _actionTile("Delete", Icons.delete, Colors.red, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Premium action button with gradient
  Widget _actionBtn(
    IconData icon,
    String label,
    bool isDark, {
    bool highlight = false,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: highlight
              ? const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                )
              : LinearGradient(
                  colors: isDark
                      ? [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.02),
                        ]
                      : [Colors.white, Colors.grey.shade200],
                ),
          border: highlight
              ? null
              : Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: highlight
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: highlight
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black54),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Color-coded detail row
  Widget _detail(
    String title,
    String value,
    IconData icon,
    bool isDark,
    Color primaryText,
    Color secondaryText,
  ) {
    Color iconColor;
    switch (title) {
      case "Time of Activity":
        iconColor = Colors.blue;
        break;
      case "Place of Activity":
        iconColor = Colors.purple;
        break;
      case "Category":
        iconColor = Colors.red;
        break;
      case "Duration":
        iconColor = Colors.orange;
        break;
      case "Device":
        iconColor = Colors.green;
        break;
      case "Description":
        iconColor = Colors.cyan;
        break;
      default:
        iconColor = Colors.teal;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: secondaryText, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(color: primaryText),
            ),
          ),
        ],
      ),
    );
  }

  // Glass action tile
  Widget _actionTile(String title, IconData icon, Color color, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.white.withOpacity(0.06), Colors.white.withOpacity(0.02)]
              : [Colors.white, Colors.grey.shade100],
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
        ],
      ),
    );
  }
}
