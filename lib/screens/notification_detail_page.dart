import 'package:flutter/material.dart';

class NotificationDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const NotificationDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text(data["title"]),
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Chip(
              label: Text(data["type"]),
              backgroundColor: Colors.deepPurple.withValues(alpha: 0.2),
            ),

            const SizedBox(height: 16),

            Text(data["text"] ?? "", style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 16),

            if (data["type"] == "Report") ...[
              _info("Report ID", "#RPT12345"),
              _info("Sector", data["sector"]),
              _info("Email", data["email"]),
              _info("Location", data["location"]),
              _info("Importance", data["importance"]),
            ],

            if (data["type"] == "Confirmation") ...[
              _info("Sector", data["sector"]),
            ],

            if (data["type"] == "Promo") ...[
              _info("Offer", "Premium Upgrade Available"),
            ],

            const SizedBox(height: 20),

            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.withValues(alpha: 0.2),
              ),
              child: const Center(child: Icon(Icons.play_circle, size: 50)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? "")),
        ],
      ),
    );
  }
}
