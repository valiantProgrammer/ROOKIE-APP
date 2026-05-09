// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:rive/rive.dart';

// class LandingPage extends StatefulWidget {
//   const LandingPage({super.key});

//   @override
//   State<LandingPage> createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage> {
//   StateMachineController? controller;
//   SMIInput<bool>? triggerLock;
//   SMIInput<bool>? triggerTrack;

//   @override
//   void initState() {
//     super.initState();
//     startSequence();
//   }

//   Future<void> startSequence() async {
//     await Future.delayed(const Duration(seconds: 2));
//     triggerLock?.value = true;

//     await Future.delayed(const Duration(seconds: 1));
//     triggerTrack?.value = true;

//     // After animation → go to next screen
//     await Future.delayed(const Duration(seconds: 2));
//     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
//   }

//   Widget glassCard({required Widget child}) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.white24),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Background glow
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: RadialGradient(
//                   colors: [Colors.white.withOpacity(0.05), Colors.black],
//                 ),
//               ),
//             ),
//           ),

//           // Center UI
//           Center(
//             child: glassCard(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(
//                     height: 200,
//                     width: 200,
//                     child: RiveAnimation.asset(
//                       'assets/rookie.riv',
//                       onInit: (artboard) {
//                         controller = StateMachineController.fromArtboard(
//                           artboard,
//                           'LoaderMachine',
//                         );

//                         if (controller != null) {
//                           artboard.addController(controller!);
//                           triggerLock = controller!.findInput<bool>(
//                             'trigger_lock',
//                           );
//                           triggerTrack = controller!.findInput<bool>(
//                             'trigger_track',
//                           );
//                         }
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   const Text(
//                     "ROOKIE SYSTEM",
//                     style: TextStyle(
//                       color: Colors.white,
//                       letterSpacing: 3,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
