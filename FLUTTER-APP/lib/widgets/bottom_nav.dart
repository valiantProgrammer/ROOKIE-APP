import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int index;
  final Function(int) onChange;

  const BottomNav({super.key, required this.index, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;

    // 👇 THIS IS THE KEY LINE
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      color: bgColor, // 👈 fills unsafe area
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 YOUR NAV BAR
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.08),
                ),
              ),
            ),
            child: Row(
              children: [
                _item(Icons.home_outlined, Icons.home, "Home", 0, context),
                _item(
                  Icons.videocam_outlined,
                  Icons.videocam,
                  "Stream",
                  1,
                  context,
                ),
                _item(
                  Icons.analytics_outlined,
                  Icons.analytics,
                  "Analysis",
                  2,
                  context,
                ),
                _item(
                  Icons.history_outlined,
                  Icons.history,
                  "History",
                  3,
                  context,
                ),
                _item(
                  Icons.person_outline,
                  Icons.person,
                  "Profile",
                  4,
                  context,
                ),
              ],
            ),
          ),

          // 🔥 THIS FILLS THE SYSTEM AREA
          SizedBox(height: bottomInset),
        ],
      ),
    );
  }

  Widget _item(
    IconData outline,
    IconData filled,
    String label,
    int i,
    BuildContext context,
  ) {
    final isSelected = index == i;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeColor = Colors.deepPurple;
    final inactiveColor = isDark ? Colors.white70 : Colors.black54;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChange(i),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: isSelected ? 1.2 : 1.0,
                child: Icon(
                  isSelected ? filled : outline,
                  size: 26,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? activeColor : inactiveColor,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
