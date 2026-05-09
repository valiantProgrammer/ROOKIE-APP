import 'package:flutter/material.dart';
import 'notification_detail_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String selectedFilter = "All";
  bool isSearching = false;
  String searchQuery = "";

  final List<Map<String, dynamic>> data = [
    {
      "type": "Report",
      "title": "Fire detected in Sector 12",
      "subtitle": "High priority incident reported",
      "time": "2 min ago",
      "importance": "High",
      "sector": "Sector 12",
      "email": "user@mail.com",
      "location": "Kolkata",
      "text": "Fire spreading rapidly near building",
      "icon": Icons.warning,
      "color": Colors.red,
      "unread": true,
    },
    {
      "type": "Report",
      "title": "Motion detected at Gate",
      "subtitle": "Unauthorized activity",
      "time": "15 min ago",
      "sector": "Sector 8",
      "text": "Unusual movement detected",
      "icon": Icons.warning,
      "color": Colors.orange,
      "unread": true,
    },
    {
      "type": "Confirmation",
      "title": "Report submitted",
      "subtitle": "Your report has been recorded",
      "time": "10 min ago",
      "sector": "Sector 5",
      "text": "Your complaint has been registered",
      "icon": Icons.check_circle,
      "color": Colors.green,
      "unread": true,
    },
    {
      "type": "Info",
      "title": "System update completed",
      "subtitle": "All components updated successfully",
      "time": "1 hr ago",
      "text": "Your system is now running latest version",
      "icon": Icons.info,
      "color": Colors.blue,
      "unread": false,
    },
    {
      "type": "Info",
      "title": "Upgrade your plan",
      "subtitle": "Get premium features now",
      "time": "2 hr ago",
      "text": "Unlock AI monitoring features",
      "icon": Icons.campaign,
      "color": Colors.purple,
      "unread": false,
    },
    {
      "type": "Confirmation",
      "title": "Settings changed",
      "subtitle": "Your preferences have been saved",
      "time": "3 hr ago",
      "text": "Alert settings updated successfully",
      "icon": Icons.settings,
      "color": Colors.cyan,
      "unread": false,
    },
  ];

  List<Map<String, dynamic>> get filteredData {
    return data.where((n) {
      final matchesFilter =
          selectedFilter == "All" ||
          (selectedFilter == "Unread" && n["unread"]) ||
          n["type"] == selectedFilter;

      final matchesSearch = n["title"].toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,

      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        title: isSearching
            ? TextField(
                autofocus: true,
                onChanged: (val) {
                  setState(() => searchQuery = val);
                },
                decoration: const InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                ),
              )
            : const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                searchQuery = "";
              });
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Stay updated with everything happening in your system.",
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),

          const SizedBox(height: 16),

          // 🔥 FILTER CARDS
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _summaryCard("All", "12", Colors.purple, Icons.notifications),
                _summaryCard(
                  "Unread",
                  "3",
                  Colors.green,
                  Icons.mark_email_unread,
                ),
                _summaryCard("Report", "2", Colors.red, Icons.warning),
                _summaryCard(
                  "Confirmation",
                  "2",
                  Colors.cyan,
                  Icons.check_circle,
                ),
                _summaryCard("Info", "2", Colors.blue, Icons.info),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ...filteredData.map((n) => _notificationItem(n)).toList(),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String count, Color color, IconData icon) {
    final isSelected = selectedFilter == title;

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = title),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? color.withValues(alpha: 0.3)
              : color.withValues(alpha: 0.1),
          border: Border.all(color: isSelected ? color : Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Text(
              count,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: 70,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationItem(Map<String, dynamic> n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NotificationDetailPage(data: n)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

          // 🔥 THEME FIX
          color: isDark ? Colors.grey.withValues(alpha: 0.1) : Colors.white,

          // 🔥 BORDER (important for light mode)
          border: Border.all(
            color: isDark
                ? Colors.transparent
                : Colors.black.withValues(alpha: 0.08),
          ),

          // 🔥 SHADOW (depth in light mode)
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),

        child: Row(
          children: [
            // ICON
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: n["color"].withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(n["icon"], color: n["color"]),
            ),

            const SizedBox(width: 12),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n["title"],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(n["subtitle"], style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),

            // 🔥 ARROW
            const Icon(Icons.arrow_outward, size: 25, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
