import 'package:flutter/material.dart';
import 'alarts_details_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware colors
    final bgColor = theme.scaffoldBackgroundColor;
    final primaryText = theme.textTheme.bodyLarge!.color!;
    final secondaryText = theme.textTheme.bodyMedium!.color!;
    final accent = Colors.deepPurple; // global accent

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "History",
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "All alerts and activities",
                        style: TextStyle(color: secondaryText, fontSize: 12),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.tune, color: primaryText),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Filter chips
              Row(
                children: [
                  _chip(
                    "All",
                    selectedFilter == "All",
                    accent,
                    primaryText,
                    isDark,
                  ),
                  _chip(
                    "Alerts",
                    selectedFilter == "Alerts",
                    accent,
                    primaryText,
                    isDark,
                  ),
                  _chip(
                    "Activity",
                    selectedFilter == "Activity",
                    accent,
                    primaryText,
                    isDark,
                  ),
                  _chip(
                    "System",
                    selectedFilter == "System",
                    accent,
                    primaryText,
                    isDark,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Today section
              if (_getFilteredItems("Today").isNotEmpty) ...[
                Text(
                  "Today",
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                ..._getFilteredItems("Today").map(
                  (item) => _card(
                    context,
                    item["time"] as String,
                    item["title"] as String,
                    item["location"] as String,
                    item["type"] as String,
                    item["color"] as Color,
                    item["image"] as String,
                    icon: item["icon"] as IconData?,
                    isDark: isDark,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Yesterday section
              if (_getFilteredItems("Yesterday").isNotEmpty) ...[
                Text(
                  "Yesterday",
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                ..._getFilteredItems("Yesterday").map(
                  (item) => _card(
                    context,
                    item["time"] as String,
                    item["title"] as String,
                    item["location"] as String,
                    item["type"] as String,
                    item["color"] as Color,
                    item["image"] as String,
                    icon: item["icon"] as IconData?,
                    isDark: isDark,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Data source
  List<Map<String, dynamic>> _getAllItems() {
    return [
      {
        "date": "Today",
        "time": "10:24 AM",
        "title": "Motion Detected",
        "location": "Front Gate Camera",
        "type": "Alerts",
        "color": Colors.red,
        "image": "https://images.unsplash.com/photo-1603899122634-f086ca5f5ddd",
        "icon": null,
      },
      {
        "date": "Today",
        "time": "09:15 AM",
        "title": "Person Detected",
        "location": "Side Entrance Camera",
        "type": "Alerts",
        "color": Colors.green,
        "image": "https://images.unsplash.com/photo-1544005313-94ddf0286df2",
        "icon": null,
      },
      {
        "date": "Today",
        "time": "08:07 AM",
        "title": "Vehicle Detected",
        "location": "Driveway Camera",
        "type": "Alerts",
        "color": Colors.red,
        "image": "https://images.unsplash.com/photo-1503376780353-7e6692767b70",
        "icon": null,
      },
      {
        "date": "Today",
        "time": "07:45 AM",
        "title": "System Started",
        "location": "NVR System",
        "type": "System",
        "color": Colors.blue,
        "image": "",
        "icon": Icons.power_settings_new,
      },
      {
        "date": "Today",
        "time": "06:30 AM",
        "title": "System Reboot",
        "location": "NVR System",
        "type": "System",
        "color": Colors.blue,
        "image": "",
        "icon": Icons.restart_alt,
      },
      {
        "date": "Today",
        "time": "05:00 AM",
        "title": "Backup Completed",
        "location": "NVR System",
        "type": "Activity",
        "color": Colors.cyan,
        "image": "",
        "icon": Icons.storage,
      },
      {
        "date": "Yesterday",
        "time": "11:30 PM",
        "title": "Motion Detected",
        "location": "Backyard Camera",
        "type": "Alerts",
        "color": Colors.red,
        "image": "https://images.unsplash.com/photo-1601758064226-0b1c2c3cbd85",
        "icon": null,
      },
      {
        "date": "Yesterday",
        "time": "09:10 PM",
        "title": "System Updated",
        "location": "NVR System",
        "type": "Activity",
        "color": Colors.blue,
        "image": "",
        "icon": Icons.system_update,
      },
      {
        "date": "Yesterday",
        "time": "06:22 PM",
        "title": "Person Detected",
        "location": "Front Gate Camera",
        "type": "Alerts",
        "color": Colors.green,
        "image": "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e",
        "icon": null,
      },
      {
        "date": "Yesterday",
        "time": "03:15 PM",
        "title": "Disk Space Low",
        "location": "NVR System",
        "type": "System",
        "color": Colors.orange,
        "image": "",
        "icon": Icons.warning,
      },
    ];
  }

  List<Map<String, dynamic>> _getFilteredItems(String date) {
    final items = _getAllItems().where((item) {
      final matchesDate = item["date"] == date;
      final matchesFilter =
          selectedFilter == "All" ||
          item["type"].toLowerCase() == selectedFilter.toLowerCase();
      return matchesDate && matchesFilter;
    }).toList();
    return items;
  }

  // Chip widget (theme-aware)
  Widget _chip(
    String text,
    bool active,
    Color accent,
    Color primaryText,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = text),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: active
              ? accent
              : (isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.05)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : primaryText,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Card widget (theme-aware)
  Widget _card(
    BuildContext context,
    String time,
    String title,
    String location,
    String type,
    Color typeColor,
    String imageUrl, {
    IconData? icon,
    required bool isDark,
    required Color primaryText,
    required Color secondaryText,
  }) {
    // Card background color (adaptive)
    final cardBg = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.05);
    // Icon/image container background
    final imagePlaceholderBg = isDark ? Colors.black : Colors.grey.shade300;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AlertDetailsPage(
              title: title,
              location: location,
              time: time,
              type: type,
              typeColor: typeColor,
              imageUrl: imageUrl,
              icon: icon,
              description:
                  "A $type event was detected at $location. This alert requires your immediate attention and review.",
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cardBg,
        ),
        child: Row(
          children: [
            // Image / Icon
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: imagePlaceholderBg,
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: icon != null ? Icon(icon, color: primaryText) : null,
            ),
            const SizedBox(width: 10),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: TextStyle(color: secondaryText, fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: TextStyle(
                      color: primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12, color: secondaryText),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(color: secondaryText, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: typeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: secondaryText),
          ],
        ),
      ),
    );
  }
}
