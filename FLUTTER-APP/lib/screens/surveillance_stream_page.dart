import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SurveillanceStreamPage extends StatefulWidget {
  final VoidCallback onBack;

  const SurveillanceStreamPage({super.key, required this.onBack});

  @override
  State<SurveillanceStreamPage> createState() => _SurveillanceStreamPageState();
}

class _SurveillanceStreamPageState extends State<SurveillanceStreamPage> {
  late VideoPlayerController _videoController;
  bool _isPlaying = false;
  double _volume = 1.0;
  bool _isRecording = false;
  List<String> _recordedFiles = [];

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _videoController = VideoPlayerController.asset('assets/videos/video-1.mp4')
      ..initialize()
          .then((_) {
            setState(() {});
          })
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading video: $error')),
            );
          });
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _videoController.pause();
        _isPlaying = false;
      } else {
        _videoController.play();
        _isPlaying = true;
      }
    });
  }

  void _setVolume(double volume) {
    setState(() {
      _volume = volume;
      _videoController.setVolume(volume);
    });
  }

  void _takeSnapshot() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📸 Snapshot captured successfully!')),
    );
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🔴 Recording started...')),
        );
      } else {
        _recordedFiles.add(
          'recording_${DateTime.now().millisecondsSinceEpoch}.mp4',
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Recording saved!')));
      }
    });
  }

  void _enterFullScreen() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: _videoController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
            if (_isRecording)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        color: Colors.white,
                        size: 12,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'REC',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final card = Theme.of(context).cardColor;
    final text = Theme.of(context).textTheme.bodyMedium!.color;

    return Container(
      color: bg,
      child: SafeArea(
        child: Column(
          children: [
            _header(),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _videoSection(),
                  const SizedBox(height: 12),
                  _quickActions(),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(child: _ptzControl(card, text)),
                      const SizedBox(width: 10),
                      Expanded(child: _presets(card, text)),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(child: _timeline(card, text)),
                      const SizedBox(width: 10),
                      Expanded(child: _events(card, text)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 HEADER
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5F2EEA), Color(0xFF7C4DFF)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBack,
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Live Stream",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Front Gate Camera",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.shield, color: Colors.white),
          const SizedBox(width: 12),
          const Icon(Icons.notifications, color: Colors.white),
        ],
      ),
    );
  }

  // 🎥 VIDEO with proper player implementation
  Widget _videoSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Video Player
          _videoController.value.isInitialized
              ? GestureDetector(
                  onTap: _togglePlayPause,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      ),
                      if (!_isPlaying)
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                    ],
                  ),
                )
              : Container(
                  height: 220,
                  width: double.infinity,
                  color: Colors.black,
                  child: const Center(child: CircularProgressIndicator()),
                ),

          // LIVE badge
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _isRecording ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _isRecording ? "REC" : "LIVE",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Left controls - Play/Pause
          Positioned(
            bottom: 10,
            left: 10,
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.6),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          // Volume Control
          Positioned(
            bottom: 10,
            left: 60,
            child: GestureDetector(
              onTap: () => _showVolumeControl(context),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.6),
                child: Icon(
                  _volume == 0 ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          // Right controls - Snapshot & Settings
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              children: [
                GestureDetector(
                  onTap: _takeSnapshot,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _enterFullScreen,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    child: const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                      size: 20,
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

  // 📱 Volume Control Dialog
  void _showVolumeControl(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Volume Control'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: _volume,
              min: 0,
              max: 1,
              divisions: 10,
              label: '${(_volume * 100).toStringAsFixed(0)}%',
              onChanged: (value) {
                setState(() {
                  _setVolume(value);
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _setVolume(0);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.volume_off),
                  label: const Text('Mute'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _setVolume(1.0);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.volume_up),
                  label: const Text('Max'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ⚡ ACTIONS
  Widget _quickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _action(Icons.camera_alt, "Snapshot", _takeSnapshot),
        _action(
          Icons.fiber_manual_record,
          _isRecording ? "Stop Rec" : "Record",
          _toggleRecording,
          isActive: _isRecording,
        ),
        _action(Icons.volume_up, "Volume", () => _showVolumeControl(context)),
        _action(Icons.warning, "Siren", () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('🔔 Siren activated!')));
        }),
        _action(Icons.lightbulb, "Light", () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('💡 Light toggled!')));
        }),
      ],
    );
  }

  Widget _action(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isActive
                ? Colors.red.withOpacity(0.3)
                : Colors.black.withOpacity(0.3),
          ),
          child: Column(
            children: [
              Icon(icon, color: isActive ? Colors.red : Colors.deepPurple),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🎮 PTZ
  Widget _ptzControl(Color card, Color? text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          Text("PTZ Control", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Icon(Icons.control_camera, size: 80),
        ],
      ),
    );
  }

  // 📷 PRESETS
  Widget _presets(Color card, Color? text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                "Camera Presets",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text("View All", style: TextStyle(color: Colors.deepPurple)),
            ],
          ),
          const SizedBox(height: 10),
          _presetItem("Preset 1", "Main Gate"),
          _presetItem("Preset 2", "Parking"),
          _presetItem("Preset 3", "Lobby"),
        ],
      ),
    );
  }

  Widget _presetItem(String title, String sub) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.image),
      title: Text(title),
      subtitle: Text(sub),
      trailing: const Icon(Icons.star_border),
    );
  }

  // 📊 TIMELINE
  Widget _timeline(Color card, Color? text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Timeline", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          LinearProgressIndicator(value: 0.5),
        ],
      ),
    );
  }

  // 🚨 EVENTS
  Widget _events(Color card, Color? text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          Row(
            children: [
              Text(
                "Recent Events",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text("View All", style: TextStyle(color: Colors.deepPurple)),
            ],
          ),
          ListTile(
            leading: Icon(Icons.directions_run),
            title: Text("Motion Detected"),
            subtitle: Text("10:30 PM"),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text("Vehicle Detected"),
            subtitle: Text("10:21 PM"),
          ),
        ],
      ),
    );
  }
}
