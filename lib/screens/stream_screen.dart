import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../services/api_service.dart';
import 'package:record/record.dart'; // 🔥 ADDED FOR AUDIO
import 'package:path_provider/path_provider.dart'; // 🔥 ADDED TO SAVE AUDIO

class Event {
  final double time;
  final String title;
  final String type;
  Event({required this.time, required this.title, required this.type});
}

class SurveillanceStreamPage extends StatefulWidget {
  final VoidCallback onBack;
  const SurveillanceStreamPage({super.key, required this.onBack});

  @override
  State<SurveillanceStreamPage> createState() => _SurveillanceStreamPageState();
}

class _SurveillanceStreamPageState extends State<SurveillanceStreamPage> {
  late VideoPlayerController controller;
  CameraController? cameraController;
  
  // 🔥 The Audio Recorder Engine
  final AudioRecorder _audioRecorder = AudioRecorder();
  
  int currentCam = 1;
  bool isMuted = false;
  double speed = 1.0;
  double currentPosition = 0;
  double totalDuration = 0;
  bool isLive = false;
  bool isPaused = false;

  bool isRecording = false;
  bool isRecordingPaused = false;
  int recordingDuration = 0;
  
  bool isLightOn = false;
  bool isSirenOn = false;
  bool isTalkOn = false;
  
  double currentZoom = 1.0;
  double maxZoom = 1.0;

  final List<String> cameras = [
    "assets/videos/video-1.mp4",
    "assets/videos/video-1.mp4",
    "assets/videos/video-1.mp4",
  ];

  final List<String> cameraNames = [
    "Front Gate Camera",
    "Side Entrance Camera",
    "Back Patio Camera",
  ];

  List<Event> events = [];
  int? selectedEventIndex;
  final ScrollController _eventScrollController = ScrollController();
  bool showSettings = false;
  double volume = 1.0;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    controller = VideoPlayerController.asset(cameras[currentCam - 1])
      ..initialize().then((_) {
        controller..play()..setLooping(true);
        controller.addListener(() {
          if (!controller.value.isInitialized) return;
          if (isLive) return; 

          final position = controller.value.position.inSeconds.toDouble();
          final duration = controller.value.duration.inSeconds.toDouble();

          if (mounted) {
            setState(() {
              currentPosition = position;
              totalDuration = duration;
            });
          }
        });
        setState(() {});
        fetchEvents();
      });
  }

  Future<void> _startLiveCamera() async {
    try {
      print("📸 Attempting to start physical camera...");
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ No cameras found!')));
        return;
      }
      
      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(backCamera, ResolutionPreset.high, enableAudio: true);
      await cameraController!.initialize();
      maxZoom = await cameraController!.getMaxZoomLevel();

      controller.pause();
      if (mounted) {
        setState(() {
          isLive = true;
          isPaused = false;
          isLightOn = false; 
        });
      }
    } catch (e) {
      print("🚨 CAMERA ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera Error: $e'), backgroundColor: Colors.red, duration: const Duration(seconds: 5)),
      );
    }
  }

  void _stopLiveCamera() {
    if (cameraController != null) {
      if (isLightOn) cameraController!.setFlashMode(FlashMode.off);
      cameraController!.dispose();
      cameraController = null;
    }
  }

  void _switchCamera(int index) {
    _stopLiveCamera();
    controller.dispose();
    currentCam = index;
    setState(() => isLive = false);
    _loadVideo();
  }

  void _takeRealSnapshot() async {
    if (isLive && cameraController != null) {
      try {
        final XFile photo = await cameraController!.takePicture();
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⏳ Uploading snapshot...')));
        
        bool success = await ApiService.uploadMedia(File(photo.path), 'snapshot', cameraNames[currentCam - 1]);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            title: Text(success ? '✅ Snapshot Saved to DB!' : '❌ Upload Failed', style: const TextStyle(fontWeight: FontWeight.bold)),
            content: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(photo.path))),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(color: Colors.deepPurple)))
            ],
          ),
        );
      } catch (e) { print(e); }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ You must GO LIVE to take a real snapshot.')));
    }
  }

  void _startRecording() async {
    if (isLive && cameraController != null) {
      try {
        await cameraController!.startVideoRecording();
        setState(() { isRecording = true; isRecordingPaused = false; recordingDuration = 0; });
        _updateRecordingTime();
      } catch (e) { print("Error starting record: $e"); }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ You must GO LIVE to record video.')));
    }
  }

  void _stopRecording() async {
    if (isLive && cameraController != null && isRecording) {
      try {
        XFile videoFile = await cameraController!.stopVideoRecording();
        setState(() { isRecording = false; isRecordingPaused = false; recordingDuration = 0; });
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⏳ Uploading video to database...')));

        bool success = await ApiService.uploadMedia(File(videoFile.path), 'video', cameraNames[currentCam - 1]);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Video successfully saved!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Failed to upload video.')));
        }
      } catch (e) { print("Error stopping record: $e"); }
    }
  }

  void _toggleLight() async {
    setState(() => isLightOn = !isLightOn);
    if (isLive && cameraController != null) {
      await cameraController!.setFlashMode(isLightOn ? FlashMode.torch : FlashMode.off);
    }
  }

  void _toggleSiren() {
    setState(() => isSirenOn = !isSirenOn);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isSirenOn ? '🚨 SIREN ACTIVATED!' : 'Siren Deactivated'), backgroundColor: isSirenOn ? Colors.red : Colors.grey[800]),
    );
  }

  // 🎤 🔥 NEW TALK / RECORD VOICE LOGIC
  void _toggleTalk() async {
    if (isTalkOn) {
      // ⏹️ STOP RECORDING & UPLOAD
      setState(() => isTalkOn = false);
      try {
        final path = await _audioRecorder.stop();
        if (path != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⏳ Uploading voice message...')));
          
          // Send the audio file to Node.js!
          bool success = await ApiService.uploadMedia(File(path), 'audio', cameraNames[currentCam - 1]);
          
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Voice message saved to Database!')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Failed to upload voice message.')));
          }
        }
      } catch (e) {
        print("Error stopping audio: $e");
      }
    } else {
      // 🔴 START RECORDING
      try {
        if (await _audioRecorder.hasPermission()) {
          final dir = await getTemporaryDirectory();
          final path = '${dir.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.m4a';
          
          await _audioRecorder.start(const RecordConfig(), path: path);
          setState(() => isTalkOn = true); // Turns the UI button Red!
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ Microphone permission denied!')));
        }
      } catch (e) {
        print("Error starting audio: $e");
      }
    }
  }

  void _zoomIn() async {
    if (isLive && cameraController != null && currentZoom < maxZoom) {
      currentZoom = (currentZoom + 0.5).clamp(1.0, maxZoom);
      await cameraController!.setZoomLevel(currentZoom);
    }
  }

  void _zoomOut() async {
    if (isLive && cameraController != null && currentZoom > 1.0) {
      currentZoom = (currentZoom - 0.5).clamp(1.0, maxZoom);
      await cameraController!.setZoomLevel(currentZoom);
    }
  }

  void _sendPTZCommand(String direction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🕹️ Moving camera: ${direction.toUpperCase()}'), duration: const Duration(milliseconds: 500), backgroundColor: Colors.deepPurple)
    );
  }

  void _enterFullScreen() {
    if (isLive && cameraController != null) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          insetPadding: EdgeInsets.zero, backgroundColor: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, child: CameraPreview(cameraController!)),
              Positioned(
                top: 40, right: 20,
                child: IconButton(icon: const Icon(Icons.close_fullscreen, color: Colors.white, size: 30), onPressed: () => Navigator.pop(context)),
              )
            ],
          ),
        ),
      );
    } 
  }

  void _updateRecordingTime() async {
    while (isRecording) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && isRecording && !isRecordingPaused) setState(() => recordingDuration++);
    }
  }

  String _formatRecordingTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> fetchEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final duration = totalDuration == 0 ? 180 : totalDuration;
    final random = Random();
    events = List.generate(8, (index) {
      return Event(
        time: duration * (0.05 + random.nextDouble() * 0.9),
        title: ["Motion Detected", "Person Detected", "Vehicle Detected"][random.nextInt(3)],
        type: ["motion", "person", "vehicle"][random.nextInt(3)],
      );
    });
    events.sort((a, b) => a.time.compareTo(b.time));
    setState(() {});
  }

  void _handleTimelineSeek(double newPosition) {
    if (isLive) {
      _stopLiveCamera();
      controller.play();
    }
    controller.seekTo(Duration(seconds: newPosition.toInt()));

    int? closestIndex;
    double minDiff = double.infinity;
    for (int i = 0; i < events.length; i++) {
      double diff = (events[i].time - newPosition).abs();
      if (diff < minDiff) { minDiff = diff; closestIndex = i; }
    }

    setState(() {
      isLive = false;
      currentPosition = newPosition;
      selectedEventIndex = closestIndex;
    });

    if (closestIndex != null) {
      _eventScrollController.animateTo(closestIndex * 80, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _stopLiveCamera();
    controller.dispose();
    _audioRecorder.dispose(); // 🔥 CLEANUP MICROPHONE
    _eventScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final card = Theme.of(context).cardColor;
    final primary = Theme.of(context).textTheme.bodyLarge!.color!;
    final secondary = Theme.of(context).textTheme.bodyMedium!.color!;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(primary, secondary),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 130),
                children: [
                  _videoSection(isDark, primary, secondary),
                  const SizedBox(height: 12),
                  _quickActions(isDark, primary),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _ptz(card, primary, secondary)),
                      const SizedBox(width: 10),
                      Expanded(child: _presets(card, primary, secondary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _timeline(card, isDark, primary, secondary),
                  const SizedBox(height: 12),
                  _events(card, isDark, primary, secondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(Color primary, Color secondary) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          GestureDetector(onTap: widget.onBack, child: Icon(Icons.arrow_back, color: primary)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Live Stream", style: TextStyle(color: primary)),
              Text(cameraNames[currentCam - 1], style: TextStyle(color: secondary, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Icon(Icons.shield, color: primary),
          const SizedBox(width: 10),
          Icon(Icons.more_vert, color: primary),
        ],
      ),
    );
  }

  Widget _videoSection(bool isDark, Color primary, Color secondary) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            height: 240,
            color: Colors.black,
            child: isLive && cameraController != null && cameraController!.value.isInitialized
                ? AspectRatio(aspectRatio: cameraController!.value.aspectRatio, child: CameraPreview(cameraController!))
                : (controller.value.isInitialized
                    ? AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller))
                    : const Center(child: CircularProgressIndicator())),
          ),

          if (isPaused && !isLive)
            Positioned.fill(
              child: GestureDetector(
                onTap: () { setState(() { controller.play(); isPaused = false; }); },
                child: Container(color: Colors.black.withOpacity(0.4), child: const Center(child: Icon(Icons.play_circle, color: Colors.white, size: 70))),
              ),
            ),

          Positioned(
            top: 10, left: 10,
            child: Row(
              children: [
                if (isRecording)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        const Icon(Icons.fiber_manual_record, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(_formatRecordingTime(recordingDuration), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: isLive ? Colors.red : Colors.grey, borderRadius: BorderRadius.circular(20)),
                    child: Text(isLive ? "LIVE" : "DELAYED", style: const TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ),
          
          if (!isLive)
            Positioned(
              top: 10, right: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(8)),
                child: Text(_formatTime(currentPosition), style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 12)),
              ),
            ),
            
          if (!isLive)
            Positioned(
              bottom: 10, left: 10,
              child: Row(
                children: [
                  _videoBtn(controller.value.isPlaying ? Icons.pause : Icons.play_arrow, () {
                    setState(() {
                      if (controller.value.isPlaying) { controller.pause(); isPaused = true; } else { controller.play(); isPaused = false; }
                    });
                  }, isDark),
                  const SizedBox(width: 10),
                  _videoBtn(isMuted ? Icons.volume_off : Icons.volume_up, () {
                    setState(() { isMuted = !isMuted; controller.setVolume(isMuted ? 0 : 1); });
                  }, isDark),
                ],
              ),
            ),
            
          Positioned(
            bottom: 10, right: 10,
            child: Row(
              children: [
                _videoBtn(Icons.fullscreen, _enterFullScreen, isDark),
                const SizedBox(width: 10),
                _videoBtn(Icons.settings, () { setState(() { showSettings = !showSettings; }); }, isDark),
              ],
            ),
          ),

          if (!isLive)
            Positioned(
              top: 60, right: 10,
              child: ElevatedButton(
                onPressed: _startLiveCamera,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 6,
                ),
                child: const Text("GO LIVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _videoBtn(IconData icon, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(backgroundColor: isDark ? Colors.black54 : Colors.white, child: Icon(icon, color: isDark ? Colors.white : Colors.black87)),
    );
  }

  Widget _quickActions(bool isDark, Color primary) {
    return Row(
      children: [
        _action(Icons.camera_alt, "Snapshot", _takeRealSnapshot, isDark, primary),
        _action(Icons.fiber_manual_record, isRecording ? "Stop" : "Record", isRecording ? _stopRecording : _startRecording, isDark, primary, isActive: isRecording),
        _action(Icons.mic, "Talk", _toggleTalk, isDark, primary, isActive: isTalkOn), // 🔥 The new logic is tied here!
        _action(Icons.warning, "Siren", _toggleSiren, isDark, primary, isActive: isSirenOn),
        _action(Icons.lightbulb, "Light", _toggleLight, isDark, primary, isActive: isLightOn),
      ],
    );
  }

  Widget _action(IconData icon, String label, VoidCallback? onTap, bool isDark, Color primary, {bool isActive = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(4), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? Colors.red.withOpacity(0.4) : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
            borderRadius: BorderRadius.circular(12), border: isActive ? Border.all(color: Colors.red.withOpacity(0.5), width: 1) : null,
          ),
          child: Column(
            children: [
              Icon(icon, color: isActive ? Colors.red : Colors.deepPurple),
              const SizedBox(height: 6),
              Text(label, style: TextStyle(color: primary, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ptzBtn(IconData icon, VoidCallback onTap, {double? top, double? bottom, double? left, double? right}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(backgroundColor: Colors.deepPurple, radius: 20, child: Icon(icon, color: Colors.white)),
      ),
    );
  }

  String _formatTime(double seconds) {
    final d = Duration(seconds: seconds.toInt());
    return "${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  Widget _cameraPresetItem(String title, VoidCallback onTap, Color primary, Color card) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.teal.withOpacity(0.2), width: 1),
        ),
        child: ListTile(
          dense: true, title: Text(title, style: TextStyle(color: primary)),
          trailing: SizedBox(width: 24, child: Icon(Icons.camera_alt, color: Colors.teal, size: 18)),
          onTap: onTap, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
      ),
    );
  }

  Widget _controlBtn(IconData icon, String label, VoidCallback onTap, Color primary) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(backgroundColor: Colors.deepPurple.withOpacity(0.3), radius: 20, child: Icon(icon, color: Colors.deepPurple)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: primary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _ptz(Color card, Color primary, Color secondary) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.deepPurple.withOpacity(0.3), width: 1.5)),
      child: Column(
        children: [
          Text("PTZ Control", style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 140, width: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _ptzBtn(Icons.keyboard_arrow_up, () => _sendPTZCommand('up'), top: 0),
                _ptzBtn(Icons.keyboard_arrow_down, () => _sendPTZCommand('down'), bottom: 0),
                _ptzBtn(Icons.keyboard_arrow_left, () => _sendPTZCommand('left'), left: 0),
                _ptzBtn(Icons.keyboard_arrow_right, () => _sendPTZCommand('right'), right: 0),
                Container(width: 50, height: 50, decoration: const BoxDecoration(color: Color.fromARGB(66, 157, 153, 153), shape: BoxShape.circle)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _controlBtn(Icons.remove, "Zoom Out", _zoomOut, primary),
              _controlBtn(Icons.add, "Zoom In", _zoomIn, primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _presets(Color card, primary, secondary) {
    return Container(
      height: 200,
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text("Camera Presets", style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 0),
              children: [
                _cameraPresetItem("Camera 1", () => _switchCamera(1), primary, card),
                _cameraPresetItem("Camera 2", () => _switchCamera(2), primary, card),
                _cameraPresetItem("Camera 3", () => _switchCamera(3), primary, card),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeline(Color card, bool isDark, Color primary, Color secondary) {
    final double timelineWidth = 1000;
    double progress = totalDuration == 0 ? 0 : currentPosition / totalDuration;
    double positionX = progress * timelineWidth;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Timeline", style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: timelineWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (i) {
                      final seconds = (totalDuration / 4 * i).toInt();
                      return Text(_formatTime(seconds.toDouble()), style: TextStyle(color: secondary));
                    }),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: timelineWidth,
                  child: GestureDetector(
                    onTapDown: (details) => _handleTimelineSeek((details.localPosition.dx / timelineWidth) * totalDuration),
                    onHorizontalDragUpdate: (details) => _handleTimelineSeek((details.localPosition.dx / timelineWidth) * totalDuration),
                    child: Stack(
                      children: [
                        Container(height: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue.withOpacity(0.08))),
                        Positioned.fill(
                          child: Row(
                            children: List.generate(40, (i) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 1), height: 8, color: Colors.grey.withOpacity(0.3)))),
                          ),
                        ),
                        Positioned(left: positionX.clamp(0, timelineWidth - 2), child: Container(width: 2, height: 40, color: Colors.deepPurple)),
                      ],
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

  Widget _events(Color card, bool isDark, Color primary, Color secondary) {
    return Container(
      height: 180, padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Events", style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Center(child: Text("Scroll timeline to view events", style: TextStyle(color: secondary)))),
        ],
      ),
    );
  }
}