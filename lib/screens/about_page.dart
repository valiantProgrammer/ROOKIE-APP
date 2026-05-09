import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final VoidCallback onBack;

  const AboutPage({super.key, required this.onBack});

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
                  onTap: onBack,
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  "About",
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
                // 🔷 ABOUT APP
                const Text(
                  "About App",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 APP CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5F2EEA), Color(0xFF7C4DFF)],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "R",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Rookie",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Version 1.2.0",
                        style: TextStyle(color: textColor!.withOpacity(0.6)),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Stream. Watch. Enjoy.",
                        style: TextStyle(color: textColor.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 📄 APP INFO
                const Text(
                  "App Info",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _tile(
                        Icons.description,
                        "Terms of Service",
                        "Read our terms and conditions",
                        textColor,
                      ),
                      _divider(),
                      _tile(
                        Icons.shield,
                        "Privacy Policy",
                        "Learn how we protect your data",
                        textColor,
                      ),
                      _divider(),
                      _tile(
                        Icons.article,
                        "Licenses",
                        "Open source licenses",
                        textColor,
                      ),
                      _divider(),
                      _tile(
                        Icons.help_outline,
                        "Help & Support",
                        "Get help and contact support",
                        textColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ⭐ MORE
                const Text(
                  "More",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _tile(
                        Icons.star,
                        "Rate the App",
                        "Share your feedback",
                        textColor,
                      ),
                      _divider(),
                      _tile(
                        Icons.share,
                        "Share the App",
                        "Tell your friends about us",
                        textColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 💜 THANK YOU CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.deepPurple.withOpacity(0.1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Thank you for using Rookie!\nWe're excited to be part of your journey.",
                          style: TextStyle(color: textColor.withOpacity(0.8)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 🔥 DECORATIVE ICON
                Icon(
                  Icons.info_outline,
                  size: 120,
                  color: Colors.deepPurple.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, String subtitle, Color? textColor) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple.withOpacity(0.1),
        child: Icon(icon, color: Colors.deepPurple),
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: textColor!.withOpacity(0.6)),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey.withOpacity(0.2));
}
