

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

late List<CameraDescription> _cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LiveCam(),
    );
  }
}

class LiveCam extends StatefulWidget {
  const LiveCam({
    super.key,
  });

  // final String title;

  @override
  State<LiveCam> createState() => _LiveCamState();
}

class _LiveCamState extends State<LiveCam> {
  late CameraController controller;
  late ImageLabeler imageLabeler;
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    initCamera();
  }

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.5);
    imageLabeler = ImageLabeler(options: options);
    controller = CameraController(
      _cameras[0],
      ResolutionPreset.max,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21 // for Android
          : ImageFormatGroup.bgra8888, // for iOS
    );
    await controller.initialize();
    if (mounted) {
      controller.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          doImageLabeling(image);
        }
        print(image.width.toString() + "   " + image.height.toString());
      });
      setState(() {});
    }
  }

  String result = "Results";
  doImageLabeling(CameraImage img) async {
    result = " ";
    InputImage? inputImage = _inputImageFromCameraImage(img);
    final List<ImageLabel> labels =
        await imageLabeler.processImage(inputImage!);

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      result += text + " " + confidence.toStringAsFixed(2) + "\n";
    }
    setState(() {
      result;
      isBusy = false;
    });
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
    final camera = _cameras[1];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[controller.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
         decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 61, 7, 7),
              Color.fromARGB(255, 112, 21, 47),
              Color.fromARGB(255, 159, 61, 19),
              Color.fromARGB(255, 214, 132, 77),
            ],
          ),
          ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (controller.value.isInitialized)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      child: CameraPreview(controller),
                      width: 335,
                      height: 495,
                    ),
                  )
                else
                  Container(),
                Text(
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      // Using Google Fonts
                      textStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 228, 233, 165),
                      ),
                    ),
                    result)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

// late List<CameraDescription> _cameras;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   _cameras = await availableCameras();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: LiveCam(),
//     );
//   }
// }

// class LiveCam extends StatefulWidget {
//   const LiveCam({Key? key}) : super(key: key);

//   @override
//   State<LiveCam> createState() => _LiveCamState();
// }

// class _LiveCamState extends State<LiveCam> {
//   late CameraController controller;
//   late ImageLabeler imageLabeler;
//   bool isBusy = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsFlutterBinding.ensureInitialized();
//     _initializeCameras();
//   }

//   Future<void> _initializeCameras() async {
//     _cameras = await availableCameras();
//     final ImageLabelerOptions options =
//         ImageLabelerOptions(confidenceThreshold: 0.5);
//     imageLabeler = ImageLabeler(options: options);
//     await _initializeController();
//   }

//   Future<void> _initializeController() async {
//     controller = CameraController(
//       _cameras[0],
//       ResolutionPreset.max,
//       imageFormatGroup: Platform.isAndroid
//           ? ImageFormatGroup.nv21 // for Android
//           : ImageFormatGroup.bgra8888, // for iOS
//     );
//     await controller.initialize();
//     if (mounted) {
//       controller.startImageStream((image) {
//         if (!isBusy) {
//           isBusy = true;
//           doImageLabeling(image);
//         }
//         print('${image.width} ${image.height}');
//       });
//       setState(() {});
//     }
//   }

//   String result = "Results";
//   Future<void> doImageLabeling(CameraImage img) async {
//     result = " ";
//     InputImage? inputImage = _inputImageFromCameraImage(img);
//     final List<ImageLabel> labels =
//         await imageLabeler.processImage(inputImage!);

//     for (ImageLabel label in labels) {
//       final String text = label.label;
//       final double confidence = label.confidence;
//       result += '$text $confidence\n';
//     }
//     setState(() {
//       result;
//       isBusy = false;
//     });
//   }

//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };

//   InputImage? _inputImageFromCameraImage(CameraImage image) {
//     final camera = _cameras[0];
//     final sensorOrientation = camera.sensorOrientation;
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//           _orientations[controller.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//       if (camera.lensDirection == CameraLensDirection.front) {
//         rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
//       } else {
//         rotationCompensation =
//             (sensorOrientation - rotationCompensation + 360) % 360;
//       }
//       rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
//     }
//     if (rotation == null) return null;

//     final format = Platform.isAndroid
//         ? InputImageFormatValue.fromRawValue(image.format.raw)
//         : InputImageFormat.bgra8888;
//     if (format == null || format != InputImageFormat.nv21) return null;

//     if (image.planes.length != 1) return null;
//     final plane = image.planes.first;

//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         rotation: rotation,
//         format: format,
//         bytesPerRow: plane.bytesPerRow,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               if (_cameras.isNotEmpty && controller.value.isInitialized)
//                 CameraPreview(controller)
//               else
//                 Container(),
//               Text(result),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
