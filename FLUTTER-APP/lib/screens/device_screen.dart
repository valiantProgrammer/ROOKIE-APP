import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Device Performance", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Status: Active"),
            Text("Battery: 82%"),
          ],
        ),
      ),
    );
  }
}
