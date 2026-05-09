import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../widgets/bottom_nav.dart';
import '../widgets/sidebar.dart';

import 'stream_screen.dart';
import 'stats_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';
import 'settings_page.dart';
import 'personal_info_page.dart';
import 'security_page.dart';
import 'privacy_page.dart';
import 'notification_settings_page.dart';
import 'language_page.dart';
import 'general_page.dart';
import 'data_storage_page.dart';
import 'about_page.dart';
import 'add_face.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChange;
  final Function(int) onNavigate;
  const HomeScreen({
    super.key,
    required this.onThemeChange,
    required this.onNavigate,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  bool showNav = true;

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeContent(),
      SurveillanceStreamPage(onBack: () => setState(() => index = 0)),
      const AnalysisPage(),
      const HistoryPage(),
      const ProfilePage(),
      const NotificationPage(), // 🔥 ADD THIS
      SettingsPage(
        onThemeChange: widget.onThemeChange,
        onNavigate: (i) => setState(() => index = i),
      ),
      PersonalInfoPage(onBack: () => setState(() => index = 6)),
      SecurityPage(onBack: () => setState(() => index = 6)),
      PrivacyPage(onBack: () => setState(() => index = 6)),
      NotificationSettingsPage(onBack: () => setState(() => index = 6)),
      LanguagePage(onBack: () => setState(() => index = 6)),
      GeneralPage(
        onBack: () => setState(() => index = 6),
        onNavigate: (i) => setState(() => index = i),
      ),
      DataStoragePage(onBack: () => setState(() => index = 6)),
      AboutPage(onBack: () => setState(() => index = 6)),
      const PeoplePage(),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      drawer: Sidebar(
        onThemeChange: widget.onThemeChange,
        onMenuSelect: (i) => setState(() => index = i),
      ),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        centerTitle: true,

        // 🔥 DYNAMIC TITLE
        title: Text(
          "ROOKIE",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),

        iconTheme: IconThemeData(color: textColor),

        actions: [
          // 🔔 NOTIFICATION BUTTON
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_none, color: textColor),

                // 🔥 OPTIONAL BADGE (remove if not needed)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              setState(() {
                index = 5; // 👉 switch to NotificationPage
              });
            },
          ),

          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // 🔥 CONTENT SWITCHING
          NotificationListener<UserScrollNotification>(
            onNotification: (scroll) {
              if (scroll.direction == ScrollDirection.reverse) {
                if (showNav) setState(() => showNav = false);
              } else if (scroll.direction == ScrollDirection.forward) {
                if (!showNav) setState(() => showNav = true);
              }
              return true;
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: screens[index],
              ),
            ),
          ),

          // 🔥 BOTTOM NAV (ON TOP)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            bottom: showNav ? 0 : -100,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !showNav,
              child: BottomNav(
                index: index,
                onChange: (i) => setState(() => index = i),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 HOME CONTENT (INDEX 0)
  Widget _buildHomeContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return ListView(
      key: const ValueKey("home"),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 130),
      children: [
        // 🔥 HERO CARD
        Container(
          height: 190,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF0F0C29),
                      const Color(0xFF302B63),
                      const Color(0xFF6C4AB6),
                    ]
                  : [
                      const Color(0xFFD1C4E9),
                      const Color(0xFFB39DDB),
                      const Color(0xFF7E57C2),
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.purple.withValues(alpha: 0.25)
                    : Colors.deepPurple.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back,",
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.7)
                          : const Color(0xFF4A4A4A),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Rupayan",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Here’s what’s happening today",
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.7)
                          : const Color(0xFF4A4A4A),
                    ),
                  ),
                  const Spacer(),

                  // 🔹 LIVE BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircleAvatar(radius: 4, backgroundColor: Colors.green),
                        SizedBox(width: 6),
                        Text("Live", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),

              // Image removed - asset doesn't exist
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 🔥 QUICK ACTIONS
        Text(
          "Quick Actions",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            _quickItem(Icons.videocam_rounded, "Go Live", textColor, 1),
            _quickItem(Icons.analytics, "Analytics", textColor, 2),
            _quickItem(Icons.history, "History", textColor, 3),
            _quickItem(Icons.settings, "Settings", textColor, 6),
          ],
        ),

        const SizedBox(height: 24),

        // 🔥 OVERVIEW
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "System Overview",
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            const Text(
              "See All",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 160,
                  child: _statCard("Devices", "3", "Active", null, textColor),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 160,
                  child: _statCard("Views", "1.2K", "+15%", null, textColor),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 160,
                  child: _statCard("Storage", "256GB", "Used", null, textColor),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // 🔥 ACTIVITY
        Text(
          "Recent Activity",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        _activity("Camera went live", "2 min ago", textColor),
        _activity("Analytics generated", "1 hr ago", textColor),
        _activity("Storage almost full", "3 hrs ago", textColor),
      ],
    );
  }

  Widget _quickItem(IconData icon, String label, Color text, int targetIndex) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            index = targetIndex;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple,
              ),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: text,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    String sub,
    Color? bg,
    Color text,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    IconData icon;
    Color accent;

    if (title.contains("Devices")) {
      icon = Icons.devices;
      accent = Colors.deepPurple;
    } else if (title.contains("Views")) {
      icon = Icons.visibility;
      accent = Colors.blue;
    } else if (title.contains("Storage")) {
      icon = Icons.storage;
      accent = Colors.green;
    } else {
      icon = Icons.bar_chart;
      accent = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        // 🔥 KEY FIX: NOT PURE WHITE
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF121212), // base dark
                  const Color(0xFF1E1E2F), // slight purple tint
                  const Color(0xFF2A1E3F), // deep purple edge
                ]
              : [const Color(0xFFF8F8FF), const Color(0xFFEDE7F6)],
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08), // 👈 visible in light
        ),

        // 🔥 STRONGER SHADOW in light
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.12), // 👈 stronger
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 ICON + TITLE
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: accent),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: text.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 🔥 VALUE
          Text(
            value,
            style: TextStyle(
              color: text,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 4),

          // 🔥 SUB TEXT
          Text(
            sub,
            style: TextStyle(
              color: sub.contains("+") ? Colors.green : accent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _activity(String title, String time, Color text) {
    IconData icon;
    Color bgColor;
    Color iconColor;

    // 🔥 CONDITION BASED UI
    if (title.toLowerCase().contains("camera")) {
      icon = Icons.video_camera_front_rounded;
      bgColor = const Color.fromARGB(255, 103, 58, 183);
      iconColor = const Color.fromARGB(255, 235, 235, 235);
    } else if (title.toLowerCase().contains("analytics")) {
      icon = Icons.analytics;
      bgColor = const Color.fromARGB(255, 30, 12, 195);
      iconColor = const Color.fromARGB(255, 164, 224, 252);
    } else if (title.toLowerCase().contains("storage")) {
      icon = Icons.storage;
      bgColor = const Color.fromARGB(255, 55, 132, 58);
      iconColor = Colors.white;
    } else {
      icon = Icons.circle;
      bgColor = Colors.grey.withValues(alpha: 0.2);
      iconColor = Colors.grey;
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,

      // 🔥 CUSTOM LEADING DESIGN
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 18),
      ),

      title: Text(title, style: TextStyle(color: text)),

      subtitle: Text(
        time,
        style: TextStyle(color: text.withValues(alpha: 0.6)),
      ),
    );
  }
}
