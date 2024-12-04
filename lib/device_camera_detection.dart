// ignore_for_file: avoid_print

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

import 'main.dart';

class DeviceCameraDetection extends StatefulWidget {
  const DeviceCameraDetection({super.key});

  @override
  State<DeviceCameraDetection> createState() => _DeviceCameraDetectionState();
}

class _DeviceCameraDetectionState extends State<DeviceCameraDetection> {
  late CameraController cameraController;
  CameraImage? imgCamera;
  bool isWorking = false;
  double? imgHeight;
  double? imgWidth;
  List? recognitionsList;
  Color indicatingColor = Colors.orange;
  List humanDetection = [];

  @override
  void initState() {
    super.initState();
    humanDetection.clear();
    loadModel();
    initCamera();
  }

  void loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt",
      );
      print("Model loaded successfully");
    } on PlatformException {
      print("Unable to load model");
    }
  }

  void initCamera() {
    cameraController =
        CameraController(cameras!.first, ResolutionPreset.medium);
    cameraController.initialize().then((_) {
      cameraController.startImageStream((imageFromStream) {
        if (!isWorking) {
          isWorking = true;
          imgCamera = imageFromStream;
          runModelOnStreamFrame();
        }
      });
    });
  }

  void runModelOnStreamFrame() async {
    if (imgCamera == null) return;

    imgHeight = imgCamera!.height.toDouble();
    imgWidth = imgCamera!.width.toDouble();

    recognitionsList = await Tflite.detectObjectOnFrame(
      bytesList: imgCamera!.planes.map((plane) => plane.bytes).toList(),
      model: "SSDMobileNet",
      imageHeight: imgCamera!.height,
      imageWidth: imgCamera!.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    );

    isWorking = false;
    try {
      setState(() {});
    } catch (e) {
      // print(e);
    }
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (recognitionsList == null || imgHeight == null || imgWidth == null) {
      return [];
    }

    double factorX = screen.width;
    double factorY = imgHeight!;

    return recognitionsList!.map((result) {
      if (result['detectedClass'] != "person") {
        return const SizedBox();
      }

      if (result['confidenceInClass'] * 100 < 50) {
        return const SizedBox();
      }

      humanDetection.add(DateTime.now());

      return Positioned(
        left: result["rect"]["x"] * factorX,
        top: result["rect"]["y"] * factorY,
        width: result["rect"]["w"] * factorX,
        height: result["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: indicatingColor, width: 2.0),
          ),
          child: Text(
            "${result['detectedClass']} ${(result['confidenceInClass'] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = indicatingColor,
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.stopImageStream();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              !cameraController.value.isInitialized
                  ? Container()
                  : CameraPreview(cameraController),
              if (imgCamera != null)
                ...displayBoxesAroundRecognizedObjects(size),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: humanDetection
                    .map((time) => Text(
                          "human detection at: $time",
                          style: const TextStyle(
                              fontFeatures: [FontFeature.tabularFigures()]),
                        ))
                    .toList()
                    .reversed
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
