import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  final Function(ThemeMode) onThemeChange;
  final Function(int) onMenuSelect;

  const Sidebar({
    super.key,
    required this.onThemeChange,
    required this.onMenuSelect,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int selectedIndex = 0;
  ThemeMode selectedTheme = ThemeMode.system;

  final List<String> items = [
    "Home",
    "Manage Account",
    "Manage Cloud",
    "Manage Devices",
    "Notifications",
    "Manage Storage",
    "Register Face",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware colors
    final primary = isDark ? Colors.white : Colors.black;
    final secondary = isDark ? Colors.white70 : Colors.black54;
    final accent = Colors.deepPurple;

    return Drawer(
      child: Container(
        // 🔥 GRADIENT BACKGROUND (not flat)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF05080F),
                    const Color(0xFF0A0F1C),
                    const Color(0xFF111827),
                  ]
                : [
                    const Color(0xFFF5F7FF),
                    const Color(0xFFEDE7F6),
                    const Color(0xFFD1C4E9),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 🔥 TITLE
              Text(
                "ROOKIE SYSTEM",
                style: TextStyle(
                  color: primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 USER CARD (GLASS EFFECT)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.white.withOpacity(0.7),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=3",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Rupayan Dey",
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.more_vert, color: primary),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🔥 MENU ITEMS
              ...List.generate(
                items.length,
                (i) =>
                    _buildItem(items[i], i, primary, secondary, accent, isDark),
              ),

              const Spacer(),

              // 🔥 THEME SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      "Theme",
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _themeButton(
                          "Default",
                          ThemeMode.system,
                          primary,
                          accent,
                          isDark,
                        ),
                        _themeButton(
                          "Dark",
                          ThemeMode.dark,
                          primary,
                          accent,
                          isDark,
                        ),
                        _themeButton(
                          "Light",
                          ThemeMode.light,
                          primary,
                          accent,
                          isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 MENU ITEM (with gradient selection + glow indicator)
  Widget _buildItem(
    String title,
    int index,
    Color primary,
    Color secondary,
    Color accent,
    bool isDark,
  ) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        Navigator.pop(context);
        widget.onMenuSelect(_mapToScreenIndex(index));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: isSelected
              ? LinearGradient(
                  colors: isDark
                      ? [
                          Colors.white.withOpacity(0.12),
                          Colors.white.withOpacity(0.05),
                        ]
                      : [accent.withOpacity(0.2), accent.withOpacity(0.1)],
                )
              : null,
        ),
        child: Row(
          children: [
            // 🔥 LEFT INDICATOR (GLOW WHEN SELECTED)
            if (isSelected)
              Container(
                width: 4,
                height: 24,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(color: accent.withOpacity(0.6), blurRadius: 10),
                  ],
                ),
              ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: primary,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 THEME BUTTON (premium gradient + border)
  Widget _themeButton(
    String text,
    ThemeMode mode,
    Color primary,
    Color accent,
    bool isDark,
  ) {
    final isSelected = selectedTheme == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTheme = mode;
        });
        widget.onThemeChange(mode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: isSelected
              ? LinearGradient(colors: [accent, accent.withOpacity(0.7)])
              : null,
          border: Border.all(
            color: isSelected
                ? accent
                : (isDark
                      ? Colors.white.withOpacity(0.3)
                      : Colors.black.withOpacity(0.2)),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : primary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // 🔥 MAP SIDEBAR INDEX TO HOME SCREEN INDEX
  int _mapToScreenIndex(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0: // Home
        return 0;
      case 1: // Manage Account → PersonalInfoPage
        return 7;
      case 2: // Manage Cloud → GeneralPage
        return 12;
      case 3: // Manage Devices → SurveillanceStreamPage
        return 1;
      case 4: // Notifications → NotificationPage
        return 5;
      case 5: // Manage Storage → DataStoragePage
        return 13;
      case 6: // Register Face → BasicInformationPage (adjust index if needed)
        return 15;
      default:
        return 0;
    }
  }
}
