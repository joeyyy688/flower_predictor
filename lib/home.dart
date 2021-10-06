// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late File _imageFile;
  final ImagePicker _picker = ImagePicker();
  late bool _loading = true;
  List? _neuralNetworkOutPut = [];

  Future<void> _pickImage() async {
    XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);

    if (pickedImage == null) return;

    final File pickedImageFile = File(pickedImage.path);
    setState(() {
      _imageFile = pickedImageFile;
    });

    classifyImage(_imageFile);

    //widget.imagePickFunction(pickedImageFile);
  }

  Future<void> _galleryImagePicker() async {
    XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) return;

    final File pickedImageFile = File(pickedImage.path);
    setState(() {
      _imageFile = pickedImageFile;
    });

    classifyImage(_imageFile);
    //widget.imagePickFunction(pickedImageFile);
  }

  void classifyImage(File image) async {
    final output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 5,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _loading = false;
      _neuralNetworkOutPut = output!;
    });
    debugPrint("the correct answer is -------------");
    debugPrint('${_neuralNetworkOutPut![0]['label']}');
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA8E063), Color(0xFF56AB2F)],
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            stops: [0.004, 1],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Detect Flowers',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 28),
              ),
              const Text(
                'Custom Tensorflow CNN',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 70,
              ),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      child: Center(
                        child: _loading
                            ? Container(
                                width: 180,
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/flower.png'),
                                    const SizedBox(
                                      height: 60,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      // decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(5),
                                      //   boxShadow: [
                                      //     BoxShadow(
                                      //       color:
                                      //           Colors.black.withOpacity(0.5),
                                      //       spreadRadius: 5,
                                      //       blurRadius: 7,
                                      //     ),
                                      //   ],
                                      // ),
                                      height: 200,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          _imageFile,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    _neuralNetworkOutPut != null
                                        ? Text(
                                            'Prediction is: ${_neuralNetworkOutPut![0]['label']}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0),
                                          )
                                        : Container(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 180,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 17,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF56ab2f),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Take a photo',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: _galleryImagePicker,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 180,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 17,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF56ab2f),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Pick Image from Gallery',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
