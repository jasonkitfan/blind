import 'package:blind_spot/drawer.dart';
import 'package:blind_spot/ip_cam_address.dart';
import 'package:blind_spot/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';

import 'device_camera_detection.dart';
import 'ext_rtsp.dart';

List<CameraDescription>? cameras;
List displayView = [
  const DeviceCameraDetection(),
  const IpCamAddress(),
  const ExtRtsp(),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  MediaKit.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => StateManagement()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text(
            "Blind Detection",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Consumer<StateManagement>(
            builder: (context, state, child) => displayView[state.currentView]),
        drawer: const NavDrawer(),
      ),
    );
  }
}
