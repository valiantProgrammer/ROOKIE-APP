import 'package:flutter/material.dart';

class DataStoragePage extends StatefulWidget {
  final VoidCallback onBack;

  const DataStoragePage({super.key, required this.onBack});

  @override
  State<DataStoragePage> createState() => _DataStoragePageState();
}

class _DataStoragePageState extends State<DataStoragePage> {
  bool dataSaver = false;

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
                  "Data & Storage",
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
                // 📊 STORAGE OVERVIEW
                const Text(
                  "Storage Overview",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // 🔥 CIRCLE CHART
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value: 0.7,
                              strokeWidth: 10,
                              backgroundColor: Colors.deepPurple.withValues(
                                alpha: 0.1,
                              ),
                              valueColor: const AlwaysStoppedAnimation(
                                Colors.deepPurple,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "3.45 GB",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("Used", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(width: 20),

                      // 🔥 LEGEND
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _legend("App Data", "1.25 GB"),
                          _legend("Cache", "1.10 GB"),
                          _legend("Other", "1.10 GB"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 📦 STORAGE MANAGEMENT
                const Text(
                  "Storage Management",
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
                      _actionTile(
                        Icons.storage,
                        "Manage Storage",
                        "Review and delete large files",
                        textColor,
                      ),
                      _divider(),

                      _valueTile(
                        Icons.delete,
                        "Clear Cache",
                        "Free up space by clearing cache",
                        "1.10 GB",
                        textColor,
                      ),
                      _divider(),

                      _valueTile(
                        Icons.download,
                        "Download Quality",
                        "Choose download quality",
                        "High",
                        textColor,
                      ),
                      _divider(),

                      _switchTile(
                        Icons.wifi,
                        "Data Saver",
                        "Reduce data usage",
                        dataSaver,
                        (v) => setState(() => dataSaver = v),
                        textColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 🔥 DECORATIVE ICON
                Icon(
                  Icons.cloud_upload,
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

  // 🔹 LEGEND
  Widget _legend(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const CircleAvatar(radius: 4, backgroundColor: Colors.deepPurple),
          const SizedBox(width: 8),
          Text(title),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // 🔹 SWITCH TILE
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

  // 🔹 VALUE TILE
  Widget _valueTile(
    IconData icon,
    String title,
    String subtitle,
    String value,
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(color: textColor)),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
    );
  }

  // 🔹 ACTION TILE
  Widget _actionTile(
    IconData icon,
    String title,
    String subtitle,
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
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  Widget _divider() =>
      Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2));
}
