import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

void main() {
  runApp(ImageLabeling());
}

class ImageLabeling extends StatefulWidget {
  ImageLabeling({Key? key}) : super(key: key);
  @override
  _ImageLabelingState createState() => _ImageLabelingState();
}

class _ImageLabelingState extends State<ImageLabeling> {
  late ImagePicker imagePicker;
  File? _image;
  String result = '';
  dynamic imageLabeler;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.5);
    imageLabeler = ImageLabeler(options: options);
  }

  @override
  void dispose() {
    super.dispose();
    imageLabeler.close();
  }

  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doImageLabeling();
    });
  }

  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doImageLabeling();
      });
    }
  }

  doImageLabeling() async {
    result = "";
    final inputImage = InputImage.fromFile(_image!);
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      result += "$text   ${confidence.toStringAsFixed(2)}\n";
    }
    setState(() {
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
      
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 100),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _imgFromGallery,
                    onLongPress: _imgFromCamera,
                    child: Icon(Icons.camera_alt),
                  ),
                ),
              ),
              Container(
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius to your preference
                        child: Image.file(
                          _image!,
                          width: 335,
                          height: 495,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Text("Please Select an Image",style: GoogleFonts.lato( // Using Google Fonts
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 228, 233, 165),
                        ),
                      )),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      result,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato( // Using Google Fonts
                        textStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 228, 233, 165),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(ImageLabeling());
// }

// class ImageLabeling extends StatefulWidget {
//   ImageLabeling({Key? key}) : super(key: key);
//   @override
//   _ImageLabelingState createState() => _ImageLabelingState();
// }

// class _ImageLabelingState extends State<ImageLabeling> {
//   late ImagePicker imagePicker;
//   File? _image;
//   String result = '';
//   dynamic imageLabeler;

//   @override
//   void initState() {
//     super.initState();
//     imagePicker = ImagePicker();
//     final ImageLabelerOptions options =
//         ImageLabelerOptions(confidenceThreshold: 0.5);
//     imageLabeler = ImageLabeler(options: options);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     imageLabeler.close();
//   }

//   _imgFromCamera() async {
//     XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
//     _image = File(pickedFile!.path);
//     setState(() {
//       _image;
//       doImageLabeling();
//     });
//   }

//   _imgFromGallery() async {
//     XFile? pickedFile =
//         await imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         doImageLabeling();
//       });
//     }
//   }

//   doImageLabeling() async {
//     result = "";
//     final inputImage = InputImage.fromFile(_image!);
//     final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
//     for (ImageLabel label in labels) {
//       final String text = label.label;
//       final int index = label.index;
//       final double confidence = label.confidence;
//       result += "$text   ${confidence.toStringAsFixed(2)}\n";
//     }
//     setState(() {
//       result;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(
//                   "images/back.jpg"), // Your background image path here
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 100),
//                 child: Center(
//                   child: ElevatedButton(
//                     onPressed: _imgFromGallery,
//                     onLongPress: _imgFromCamera,
//                     child: Icon(Icons.camera_alt),
//                   ),
//                 ),
//               ),
//               Container(
//                 child: _image != null
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(
//                             20), // Adjust the radius to your preference
//                         child: Image.file(
//                           _image!,
//                           width: 335,
//                           height: 495,
//                           fit: BoxFit.fill,
//                         ),
//                       )
//                     : Text("Please Select an Image"),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 20),
//                     child: Text(
//                       result,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                           fontSize: 25, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(ImageLabeling());
// }

// class ImageLabeling extends StatefulWidget {
//   ImageLabeling({Key? key}) : super(key: key);
//   @override
//   _ImageLabelingState createState() => _ImageLabelingState();
// }

// class _ImageLabelingState extends State<ImageLabeling> {
//   late ImagePicker imagePicker;
//   File? _image;
//   String result = '';
//   dynamic imageLabeler;

//   @override
//   void initState() {
//     super.initState();
//     imagePicker = ImagePicker();
//     final ImageLabelerOptions options =
//         ImageLabelerOptions(confidenceThreshold: 0.5);
//     imageLabeler = ImageLabeler(options: options);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     imageLabeler.close();
//   }

//   _imgFromCamera() async {
//     XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
//     _image = File(pickedFile!.path);
//     setState(() {
//       _image;
//       doImageLabeling();
//     });
//   }

//   _imgFromGallery() async {
//     XFile? pickedFile =
//         await imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         doImageLabeling();
//       });
//     }
//   }

//   doImageLabeling() async {
//     result = "";
//     final inputImage = InputImage.fromFile(_image!);
//     final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
//     for (ImageLabel label in labels) {
//       final String text = label.label;
//       final int index = label.index;
//       final double confidence = label.confidence;
//       result += "$text   ${confidence.toStringAsFixed(2)}\n";
//     }
//     setState(() {
//       result;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("images/back.jpg"),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 100),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: _imgFromGallery,
//                       icon: Icon(Icons.photo),
//                       label: Text("Select from Gallery"),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: _imgFromCamera,
//                       icon: Icon(Icons.camera_alt),
//                       label: Text("Capture from Camera"),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(vertical: 20),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black, width: 2),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 3,
//                       blurRadius: 5,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: _image != null
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Image.file(
//                           _image!,
//                           width: 335,
//                           height: 495,
//                           fit: BoxFit.fill,
//                         ),
//                       )
//                     : Text("Please Select an Image"),
//               ),
//               Expanded(
//                 child: Container(
//                   padding: EdgeInsets.all(20),
//                   margin: EdgeInsets.only(top: 20),
//                   color: Colors.white.withOpacity(0.8),
//                   child: SingleChildScrollView(
//                     child: Text(
//                       result,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(ImageLabeling());
// }

// class ImageLabeling extends StatefulWidget {
//   ImageLabeling({Key? key}) : super(key: key);
//   @override
//   _ImageLabelingState createState() => _ImageLabelingState();
// }

// class _ImageLabelingState extends State<ImageLabeling> {
//   late ImagePicker imagePicker;
//   File? _image;
//   String result = '';
//   dynamic imageLabeler;

//   @override
//   void initState() {
//     super.initState();
//     imagePicker = ImagePicker();
//     final ImageLabelerOptions options =
//         ImageLabelerOptions(confidenceThreshold: 0.5);
//     imageLabeler = ImageLabeler(options: options);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     imageLabeler.close();
//   }

//   _imgFromCamera() async {
//     XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
//     _image = File(pickedFile!.path);
//     setState(() {
//       _image;
//       doImageLabeling();
//     });
//   }

//   _imgFromGallery() async {
//     XFile? pickedFile =
//         await imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         doImageLabeling();
//       });
//     }
//   }

//   doImageLabeling() async {
//     result = "";
//     final inputImage = InputImage.fromFile(_image!);
//     final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
//     for (ImageLabel label in labels) {
//       final String text = label.label;
//       final int index = label.index;
//       final double confidence = label.confidence;
//       result += "$text   ${confidence.toStringAsFixed(2)}\n";
//     }
//     setState(() {
//       result;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xFFECEFF1),
//                 Color(0xFFB0BEC5),
//               ],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 50),
//               Text(
//                 'Image Labeling App',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.indigo,
//                 ),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: _imgFromGallery,
//                       icon: Icon(Icons.photo),
//                       label: Text("Select from Gallery"),
//                       style: ElevatedButton.styleFrom(
//                         // primary: Colors.white, // <-- Primary color
//                         // onPrimary: Colors.indigo, // <-- On-primary color
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: _imgFromCamera,
//                       icon: Icon(Icons.camera_alt),
//                       label: Text("Capture from Camera"),
//                       style: ElevatedButton.styleFrom(
//                         // primary: Colors.white, // <-- Primary color
//                         // onPrimary: Colors.indigo, // <-- On-primary color
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 20),
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 3,
//                       blurRadius: 5,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: _image != null
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Image.file(
//                           _image!,
//                           width: double.infinity,
//                           height: 300,
//                           fit: BoxFit.cover,
//                         ),
//                       )
//                     : Text(
//                         "Please Select an Image",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey,
//                         ),
//                       ),
//               ),
//               SizedBox(height: 20),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: 20),
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       result,
//                       textAlign: TextAlign.center,
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(ImageLabeling());
// }

// class ImageLabeling extends StatefulWidget {
//   ImageLabeling({Key? key}) : super(key: key);
//   @override
//   _ImageLabelingState createState() => _ImageLabelingState();
// }

// class _ImageLabelingState extends State<ImageLabeling> {
//   late ImagePicker imagePicker;
//   File? _image;
//   String result = '';
//   dynamic imageLabeler;

//   @override
//   void initState() {
//     super.initState();
//     imagePicker = ImagePicker();
//     final ImageLabelerOptions options =
//         ImageLabelerOptions(confidenceThreshold: 0.5);
//     imageLabeler = ImageLabeler(options: options);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     imageLabeler.close();
//   }

//   _imgFromCamera() async {
//     XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
//     _image = File(pickedFile!.path);
//     setState(() {
//       _image;
//       doImageLabeling();
//     });
//   }

//   _imgFromGallery() async {
//     XFile? pickedFile =
//         await imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         doImageLabeling();
//       });
//     }
//   }

//   doImageLabeling() async {
//     result = "";
//     final inputImage = InputImage.fromFile(_image!);
//     final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
//     for (ImageLabel label in labels) {
//       final String text = label.label;
//       final int index = label.index;
//       final double confidence = label.confidence;
//       result += "$text   ${confidence.toStringAsFixed(2)}\n";
//     }
//     setState(() {
//       result;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Colors.white, // Define primary color
//         colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.indigo), // Define on-primary color
//       ),
//       home: Scaffold(
//         body: Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("images/back.jpg"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Container(
//                 color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
//               ),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'Image Labeling App',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: _imgFromGallery,
//                       icon: Icon(Icons.photo),
//                       label: Text("Select from Gallery"),
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: _imgFromCamera,
//                       icon: Icon(Icons.camera_alt),
//                       label: Text("Capture from Camera"),
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 20),
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 3,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: _image != null
//                       ? ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: Image.file(
//                             _image!,
//                             width: double.infinity,
//                             height: 300,
//                             fit: BoxFit.cover,
//                           ),
//                         )
//                       : Text(
//                           "Please Select an Image",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey,
//                           ),
//                         ),
//                 ),
//                 SizedBox(height: 20),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Container(
//                       margin: EdgeInsets.symmetric(horizontal: 20),
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         result,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



