import 'package:flutter/material.dart';
import 'live_cam.dart';
import 'image_labeling.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Lenses",
          style: TextStyle(color: Color.fromARGB(255, 228, 233, 165)),
        ),
        backgroundColor: Color.fromARGB(255, 32, 3, 3), // Changed app bar color
      ),
      backgroundColor:
          const Color.fromARGB(255, 184, 141, 141), // Changed background color
      body: Menu(),
    ),
  ));
}

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Features("AI Image Labeler", ImageLabeling()),
        Features("Live AI Camera", LiveCam()),

      ],
    );
  }
}

class Features extends StatelessWidget {
  final String text;
  final Widget? featurePage;

  Features(this.text, this.featurePage);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: 100,
      width: double.infinity,
      // padding: const EdgeInsets.all(32),
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
          borderRadius: BorderRadius.circular(16)),
      child: TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => featurePage!));
          },
          child: Text(
            text,
            style: TextStyle(
                fontSize: 20, color: Color.fromARGB(255, 228, 233, 165)),
          )),
    );
  }
}
