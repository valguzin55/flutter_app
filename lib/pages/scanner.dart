import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:flutter_auth/main.dart';
import 'package:flutter_auth/pages/addRequest.dart';
import 'package:flutter_auth/pages/addbookpage.dart';
import 'package:flutter_auth/pages/backRequest.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CameraAppTest extends StatelessWidget {
  static const routeName = '/videoRecordScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // width: 200,
        alignment: Alignment.center,
        // margin: EdgeInsets.all(24),
        // padding: EdgeInsets.all(24),
        decoration: BoxDecoration(),
        // decoration: ,
        child: Container(child: Demo()),
      ),
    );
  }
}

class Demo extends StatefulWidget {
  @override
  _Demo createState() => _Demo();
}

class _Demo extends State<Demo> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  cameraCode(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }

  Widget build(context) {
    return Container(
      //margin: EdgeInsets.only(bottom: 20, right: 20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // margin: EdgeInsets.only(bottom: 30),
            child: cameraCode(context),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Text("Добавить"),
                    onPressed: () async {
                      final image = await controller.takePicture();
                      final imageP = InputImage.fromFilePath(image.path);
                      final textDetector = GoogleMlKit.vision.textDetector();
                      final RecognisedText recognisedText =
                          await textDetector.processImage(imageP);
                      String isbn;

                      for (TextBlock block in recognisedText.blocks) {
                        for (TextLine line in block.lines) {
                          // Same getters as TextBlock

                          if (line.text.startsWith("ISBN")) {
                            isbn = line.text.split(" ")[1];
                          }
                        }
                      }
                      if (isbn != null) {
                        dynamic data = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .get();
                        //if (data['role'] != 'user')

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddWidget(
                                      isbn: isbn,
                                    )));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("ISBN не найден"),
                        ));
                      }
                    },
                  ),
                  ElevatedButton(
                      child: Text("Взять"),
                      onPressed: () async {
                        final image = await controller.takePicture();
                        final imageP = InputImage.fromFilePath(image.path);
                        final textDetector = GoogleMlKit.vision.textDetector();
                        final RecognisedText recognisedText =
                            await textDetector.processImage(imageP);
                        String isbn;

                        for (TextBlock block in recognisedText.blocks) {
                          for (TextLine line in block.lines) {
                            // Same getters as TextBlock

                            if (line.text.startsWith("ISBN")) {
                              isbn = line.text.split(" ")[1];
                            }
                          }
                        }
                        if (isbn != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddRequest(
                                        isbn: isbn,
                                      )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("ISBN не найден"),
                          ));
                        }
                      }),
                  ElevatedButton(
                      child: Text("Возвратить"),
                      onPressed: () async {
                        final image = await controller.takePicture();
                        final imageP = InputImage.fromFilePath(image.path);
                        final textDetector = GoogleMlKit.vision.textDetector();
                        final RecognisedText recognisedText =
                            await textDetector.processImage(imageP);
                        String isbn;

                        for (TextBlock block in recognisedText.blocks) {
                          for (TextLine line in block.lines) {
                            // Same getters as TextBlock

                            if (line.text.startsWith("ISBN")) {
                              isbn = line.text.split(" ")[1];
                            }
                          }
                        }
                        if (isbn != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BackRequest(
                                        isbn: isbn,
                                      )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("ISBN не найден"),
                          ));
                        }
                      }),
                ],
              )),

          // Square(),
        ],
      ),
    );
  }
}
