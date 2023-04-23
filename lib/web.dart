import 'dart:html';

import 'package:camera/camera.dart';
import 'package:camera_web/camera_web.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  MobileScannerController mobileScannerController = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('qr'),
      ),
      //body: Cam,
      body: MobileScanner(
        allowDuplicates: true,
        controller: mobileScannerController,
        onDetect: _foundBarcode,
      ),
    );
  }

  void _foundBarcode(
      Barcode barcode, MobileScannerArguments? mobileScannerArguments) {
    final String string = barcode.rawValue ?? '---';
    debugPrint(string);
  }
}


class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(title: Text('Camera test')),
          body: AppBody(),
        );
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  bool cameraAccess = false;
  String? error;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    getCameras();
    super.initState();
  }

  Future<void> getCameras() async {
    try {
      await window.navigator.mediaDevices!
          .getUserMedia({'video': true, 'audio': false});
      setState(() {
        cameraAccess = true;
      });
      final cameras = await availableCameras();
      setState(() {
        this.cameras = cameras;
      });
    } on DomException catch (e) {
      setState(() {
        error = '${e.name}: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(child: Text('Error: $error'));
    }
    if (!cameraAccess) {
      return Center(child: Text('Camera access not granted yet.'));
    }
    if (cameras == null) {
      return Center(child: Text('Reading cameras'));
    }
    return CameraView(cameras: cameras!);
  }
}

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraView({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  String? error;
  CameraController? controller;
  late CameraDescription cameraDescription = widget.cameras[0];

  Future<void> initCam(CameraDescription description) async {
    setState(() {
      controller = CameraController(description, ResolutionPreset.max);
    });

    try {
      await controller!.initialize();
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initCam(cameraDescription);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(
        child: Text('Initializing error: $error\nCamera list:'),
      );
    }
    if (controller == null) {
      return Center(child: Text('Loading controller...'));
    }
    if (!controller!.value.isInitialized) {
      return Center(child: Text('Initializing camera...'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          AspectRatio(aspectRatio: 16 / 9, child: CameraPreview(controller!)),
          Material(
            child: DropdownButton<CameraDescription>(
              value: cameraDescription,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              onChanged: (CameraDescription? newValue) async {
                if (controller != null) {
                  await controller!.dispose();
                }
                setState(() {
                  controller = null;
                  cameraDescription = newValue!;
                });

                initCam(newValue!);
              },
              items: widget.cameras
                  .map<DropdownMenuItem<CameraDescription>>((value) {
                return DropdownMenuItem<CameraDescription>(
                  value: value,
                  child: Text('${value.name}: ${value.lensDirection}'),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: controller == null
                ? null
                : () async {
              await controller!.startVideoRecording();
              await Future.delayed(Duration(seconds: 5));
              final file = await controller!.stopVideoRecording();
              final bytes = await file.readAsBytes();
              final uri = Uri.dataFromBytes(bytes,
                  mimeType: 'video/webm;codecs=vp8');

              final link = AnchorElement(href: uri.toString());
              link.download = 'recording.webm';
              link.click();
              link.remove();
            },
            child: Text('Record 5 second video.'),
          ),
          ElevatedButton(
            onPressed: controller == null
                ? null
                : () async {
              final file = await controller!.takePicture();
              final bytes = await file.readAsBytes();

              final link = AnchorElement(
                  href: Uri.dataFromBytes(bytes, mimeType: 'image/png')
                      .toString());

              link.download = 'picture.png';
              link.click();
              link.remove();
            },
            child: Text('Take picture.'),
          )
        ],
      ),
    );
  }
}