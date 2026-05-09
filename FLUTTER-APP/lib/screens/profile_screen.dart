import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;

  String name = "Rupayan Dey";
  String email = "rupayan@example.com";
  String location = "Kolkata, India";

  List<String> deviceIds = ["Device-AX92K", "Device-ZX10P", "Device-MOB-445"];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = name;
    locationController.text = location;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E2F) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      color: bgColor,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 130),
          children: [
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=3",
                    ),
                  ),

                  const SizedBox(height: 12),

                  isEditing
                      ? TextField(
                          controller: nameController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(color: subtextColor),
                          ),
                        )
                      : Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),

                  const SizedBox(height: 6),

                  Text(email, style: TextStyle(color: subtextColor)),

                  const SizedBox(height: 10),

                  isEditing
                      ? TextField(
                          controller: locationController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: "Location",
                            labelStyle: TextStyle(color: subtextColor),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: subtextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              location,
                              style: TextStyle(color: subtextColor),
                            ),
                          ],
                        ),

                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () {
                      if (isEditing) {
                        setState(() {
                          name = nameController.text;
                          location = locationController.text;
                        });
                      }
                      setState(() => isEditing = !isEditing);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C4DFF),
                    ),
                    child: Text(
                      isEditing ? "Save" : "Edit Profile",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Your Devices",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),

            const SizedBox(height: 10),

            ...deviceIds.map((device) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.3 : 0.05,
                      ),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.devices, color: Colors.deepPurple),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(device, style: TextStyle(color: textColor)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
