import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'face_camera_page.dart';
import '../services/api_service.dart';
import 'models/person_model.dart'; // make sure this import exists
// import 'review_page.dart';            // no longer needed

class BasicInformationPage extends StatefulWidget {
  const BasicInformationPage({super.key});

  @override
  State<BasicInformationPage> createState() => _BasicInformationPageState();
}

class _BasicInformationPageState extends State<BasicInformationPage>
    with SingleTickerProviderStateMixin {
  // Step management
  int currentStep = 1;

  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _idController;

  // Captured faces state
  final Map<String, bool> _capturedFaces = {
    'Left Profile': false,
    'Front Profile': false,
    'Right Profile': false,
  };

  final Map<String, File> _imageFiles ={};

  // Draft data store (in memory)
  Map<String, dynamic> _draftData = {};

  // Jiggle animation
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _idController = TextEditingController();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 8,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    _loadDraftData();
  }

  void _loadDraftData() {
    if (_draftData.containsKey('name')) {
      _nameController.text = _draftData['name'];
    }
    if (_draftData.containsKey('id')) {
      _idController.text = _draftData['id'];
    }
    if (_draftData.containsKey('capturedFaces')) {
      final saved = _draftData['capturedFaces'] as Map<String, bool>;
      _capturedFaces.forEach((key, _) {
        if (saved.containsKey(key)) _capturedFaces[key] = saved[key]!;
      });
    }
  }

  void _saveDraftData() {
    setState(() {
      _draftData['name'] = _nameController.text;
      _draftData['id'] = _idController.text;
      _draftData['capturedFaces'] = Map.from(_capturedFaces);
    });
  }

  bool _canMoveToStep(int step) {
    if (step == 2) {
      return _nameController.text.isNotEmpty && _idController.text.isNotEmpty;
    }
    if (step == 3) {
      return _capturedFaces.values.every((v) => v);
    }
    return true;
  }

  void _triggerJiggle() {
    _shakeController.forward(from: 0);
  }

  void _goToNextStep() {
    if (currentStep < 3) {
      if (!_canMoveToStep(currentStep + 1)) {
        _triggerJiggle();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentStep == 1
                  ? "Complete Basic Info first"
                  : "Capture all face angles first",
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }
      if (currentStep == 1) _saveDraftData();
      setState(() => currentStep++);
    } else {
      _submit();
    }
  }

  void _goToPreviousStep() {
    if (currentStep > 1) setState(() => currentStep--);
  }

  // 🚀 SUBMIT – registers the person directly
  void _submit() async {
    _saveDraftData();
    final allCaptured = _capturedFaces.values.every((v) => v);
    if (!allCaptured) {
      _triggerJiggle();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture all face angles')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.deepPurple),
      ),
    );

    List<File> filesToSend = _imageFiles.values.toList();

    bool success = await ApiService.registerPerson(_nameController.text,_idController.text, filesToSend);

    Navigator.pop(context);

    if(success){
      // Create and save the registered person
      final person = RegisteredPerson(
        name: _nameController.text,
        id: _idController.text,
        registrationDate: DateTime.now().toString().split(' ')[0],
        status: 'Authorized',
        capturedFaces: _capturedFaces,
      );
      PersonService().addPerson(person);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Person registered successfully!')),
      );
      // Navigate back to the people page (close all dialogs/pages until the first)
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Server Registration Failed'))
      );
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.textTheme.bodyLarge!.color!;
    final secondary = theme.textTheme.bodyMedium!.color!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF05080F),
                    const Color(0xFF0A0F1C),
                    const Color(0xFF111827),
                  ]
                : [Colors.grey.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, color: primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Basic Information",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
                const SizedBox(height: 16),

                // Clickable steps
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _step("1", "Basic Info", 1, isDark, secondary),
                    _line(isDark),
                    _step("2", "Capture Faces", 2, isDark, secondary),
                    _line(isDark),
                    _step("3", "Review", 3, isDark, secondary),
                  ],
                ),
                const SizedBox(height: 20),

                // Step content with swipe + jiggle
                Expanded(
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! > 0){
                        _goToPreviousStep();
                      }else if (details.primaryVelocity! < 0){
                        _goToNextStep();
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.3, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: AnimatedBuilder(
                        animation: _shakeController,
                        builder: (context, child) {
                          final shakeValue = _shakeAnimation.value;
                          return Transform.translate(
                            offset: Offset(
                              shakeValue *
                                  ((_shakeController.value * 10).toInt() % 2 ==
                                          0
                                      ? 1
                                      : -1),
                              0,
                            ),
                            child: child,
                          );
                        },
                        child: _buildStepContent(isDark, primary, secondary),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Navigation buttons
                Row(
                  children: [
                    if (currentStep > 1)
                      Expanded(
                        child: GestureDetector(
                          onTap: _goToPreviousStep,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.grey.shade200,
                            ),
                            child: Center(
                              child: Text(
                                "← Previous",
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (currentStep > 1) const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                          ),
                        ),
                        child: GestureDetector(
                          onTap: _goToNextStep,
                          child: Center(
                            child: Text(
                              currentStep == 3 ? "Submit →" : "Next →",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------
  // Step content
  // --------------------------------------------------------------
  Widget _buildStepContent(bool isDark, Color primary, Color secondary) {
    switch (currentStep) {
      case 1:
        return Column(
          children: [
            _card(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Basic Information", Icons.person, primary),
                  const SizedBox(height: 10),
                  _input(
                    "Full Name",
                    "Enter full name",
                    _nameController,
                    isDark,
                    primary,
                    secondary,
                  ),
                  const SizedBox(height: 10),
                  _input(
                    "ID / Employee Number",
                    "Enter employee ID",
                    _idController,
                    isDark,
                    primary,
                    secondary,
                  ),
                ],
              ),
            ),
          ],
        );

      case 2:
        return _card(
          isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title("Capture Face Images", Icons.camera_alt, primary),
              Text(
                "Capture clear images in all required angles",
                style: TextStyle(color: secondary, fontSize: 11),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _captureBox("Left Profile", 'Left Profile', isDark),
                  _captureBox("Front Profile", 'Front Profile', isDark),
                  _captureBox("Right Profile", 'Right Profile', isDark),
                ],
              ),
              const SizedBox(height: 16),
              _card(
                isDark,
                gradient: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "💡 Tips for best results",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "• Use good lighting",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      "• Remove glasses, hats or masks",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      "• Keep a neutral expression",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      // ========================
      //  STEP 3 – ENHANCED REVIEW (embedded ReviewPage content)
      // ========================
      case 3:
        return SingleChildScrollView(
          child: Column(
            children: [
              // Personal details card
              _card(
                isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title("Personal Details", Icons.person, primary),
                    const SizedBox(height: 12),
                    _detailRow(
                      "Full Name:",
                      _nameController.text,
                      primary,
                      secondary,
                    ),
                    const SizedBox(height: 8),
                    _detailRow(
                      "Employee ID:",
                      _idController.text,
                      primary,
                      secondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Captured faces card with previews
              _card(
                isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title("Captured Face Images", Icons.camera_alt, primary),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _facePreview(
                          "Front Profile",
                          _capturedFaces["Front Profile"] ?? false,
                        ),
                        _facePreview(
                          "Left Profile",
                          _capturedFaces["Left Profile"] ?? false,
                        ),
                        _facePreview(
                          "Right Profile",
                          _capturedFaces["Right Profile"] ?? false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Confirmation card (gradient)
              _card(
                isDark,
                gradient: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green, size: 32),
                    SizedBox(height: 8),
                    Text(
                      "All information is correct",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Click Submit to register this person",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      default:
        return const SizedBox();
    }
  }

  // Helper widgets (same as before)
  Widget _detailRow(
    String label,
    String value,
    Color primary,
    Color secondary,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: secondary, fontSize: 12)),
        Text(
          value,
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _facePreview(String title, bool isCaptured) {
    // Light/dark handled by parent, but we keep consistent colors
    return Column(
      children: [
        Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isCaptured ? Colors.green.shade700 : Colors.black26,
            border: Border.all(
              color: isCaptured ? Colors.green.shade400 : Colors.white24,
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              isCaptured ? Icons.check_circle : Icons.person,
              color: isCaptured ? Colors.white : Colors.white54,
              size: isCaptured ? 28 : 32,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _missingFaces() {
    final missing = _capturedFaces.entries
        .where((e) => !e.value)
        .map((e) => e.key)
        .join(', ');
    return missing.isEmpty ? "None" : missing;
  }

  Widget _reviewTile(
    String label,
    String value,
    Color primary,
    Color secondary,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: secondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: primary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _captureBox(String title, String key, bool isDark) {
    final captured = _capturedFaces[key] ?? false;
    return Column(
      children: [
        Container(
          width: 90,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: captured
                ? Colors.green.shade700
                : (isDark ? Colors.black26 : Colors.grey.shade300),
          ),
          child: Center(
            child: Icon(
              captured ? Icons.check_circle : Icons.person,
              color: captured
                  ? Colors.white
                  : (isDark ? Colors.white54 : Colors.black54),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {

            final ImagePicker picker = ImagePicker();

            final XFile? photo = await picker.pickImage(
              source: ImageSource.camera,
              preferredCameraDevice: CameraDevice.front,
            );

            if(photo != null){
              setState(() {
                _capturedFaces[key] = true;
                _imageFiles[key] = File(photo.path);
                _saveDraftData();
              });
            }
          },
          child: CircleAvatar(
            radius: 14,
            backgroundColor: captured
                ? Colors.green.shade600
                : Colors.deepPurple,
            child: Icon(
              captured ? Icons.check : Icons.camera_alt,
              size: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _step(
    String num,
    String label,
    int stepIndex,
    bool isDark,
    Color secondary,
  ) {
    final isActive = currentStep == stepIndex;
    final isCompleted = currentStep > stepIndex;
    return GestureDetector(
      onTap: () {
        if (_canMoveToStep(stepIndex)) {
          setState(() => currentStep = stepIndex);
        } else {
          _triggerJiggle();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                stepIndex == 2
                    ? "Complete Basic Info first"
                    : "Capture all face angles first",
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: isActive
                ? Colors.deepPurple
                : (isCompleted
                      ? Colors.green
                      : (isDark ? Colors.white24 : Colors.black12)),
            child: Text(
              isCompleted ? "✓" : num,
              style: TextStyle(
                fontSize: 12,
                color: isActive || isCompleted ? Colors.white : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? Colors.deepPurple
                  : (isDark ? Colors.white70 : secondary),
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(bool isDark) =>
      Expanded(child: Divider(color: isDark ? Colors.white24 : Colors.black26));

  Widget _card(bool isDark, {required Widget child, bool gradient = false}) {
    return Container(
      padding: const EdgeInsets.all(14),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: gradient
            ? const LinearGradient(
                colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
              )
            : LinearGradient(
                colors: isDark
                    ? [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.02),
                      ]
                    : [Colors.white, Colors.grey.shade100],
              ),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: child,
    );
  }

  Widget _title(String text, IconData icon, Color primary) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 18),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(color: primary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _input(
    String label,
    String hint,
    TextEditingController controller,
    bool isDark,
    Color primary,
    Color secondary,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: secondary, fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.shade200,
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: primary),
            onChanged: (_) => _saveDraftData(),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: secondary.withOpacity(0.6)),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
