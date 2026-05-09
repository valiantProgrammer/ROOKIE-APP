import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  final VoidCallback onBack;

  const PersonalInfoPage({super.key, required this.onBack});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  bool isEditing = false;

  String fullName = "John Doe";
  String email = "john.doe@email.com";
  String phone = "+1 234 567 890";
  String location = "New York, USA";
  String dateOfBirth = "12 Jan 1995";

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController dobController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: fullName);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: phone);
    locationController = TextEditingController(text: location);
    dobController = TextEditingController(text: dateOfBirth);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    dobController.dispose();
    super.dispose();
  }

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
                  "Personal Information",
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
                // 🔥 PROFILE CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFF6C4AB6),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            email,
                            style: TextStyle(
                              color: textColor!.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Profile Details",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 DETAILS CARD
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: cardColor,
                  ),
                  child: Column(
                    children: [
                      isEditing
                          ? _editItem(
                              Icons.person,
                              "Full Name",
                              nameController,
                              textColor,
                            )
                          : _item(
                              Icons.person,
                              "Full Name",
                              fullName,
                              textColor,
                            ),
                      _divider(),
                      isEditing
                          ? _editItem(
                              Icons.email,
                              "Email Address",
                              emailController,
                              textColor,
                            )
                          : _item(
                              Icons.email,
                              "Email Address",
                              email,
                              textColor,
                            ),
                      _divider(),
                      isEditing
                          ? _editItem(
                              Icons.phone,
                              "Phone Number",
                              phoneController,
                              textColor,
                            )
                          : _item(
                              Icons.phone,
                              "Phone Number",
                              phone,
                              textColor,
                            ),
                      _divider(),
                      isEditing
                          ? _editItem(
                              Icons.location_on,
                              "Location",
                              locationController,
                              textColor,
                            )
                          : _item(
                              Icons.location_on,
                              "Location",
                              location,
                              textColor,
                            ),
                      _divider(),
                      isEditing
                          ? _editItem(
                              Icons.calendar_today,
                              "Date of Birth",
                              dobController,
                              textColor,
                            )
                          : _item(
                              Icons.calendar_today,
                              "Date of Birth",
                              dateOfBirth,
                              textColor,
                            ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔥 BUTTON
                GestureDetector(
                  onTap: () {
                    if (isEditing) {
                      setState(() {
                        fullName = nameController.text;
                        email = emailController.text;
                        phone = phoneController.text;
                        location = locationController.text;
                        dateOfBirth = dobController.text;
                      });
                    }
                    setState(() => isEditing = !isEditing);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5F2EEA), Color(0xFF7C4DFF)],
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isEditing ? Icons.check : Icons.edit,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isEditing ? "Save Profile" : "Update Profile",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 LIST ITEM (Display Mode)
  Widget _item(IconData icon, String title, String subtitle, Color? textColor) {
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
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.deepPurple,
      ),
    );
  }

  // 🔥 EDIT ITEM (Edit Mode)
  Widget _editItem(
    IconData icon,
    String title,
    TextEditingController controller,
    Color? textColor,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
        child: Icon(icon, color: Colors.deepPurple),
      ),
      title: TextField(
        controller: controller,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: title,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _divider() =>
      Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2));
}
