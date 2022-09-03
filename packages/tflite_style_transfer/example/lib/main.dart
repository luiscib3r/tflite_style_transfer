// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tflite_style_transfer/tflite_style_transfer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Style Transfer',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imagePicker = ImagePicker();
  final styleTransfer = TFLiteStyleTransfer();

  static final styleImages = List.generate(
    26,
    (index) => 'assets/styles/style$index.jpg',
  );

  bool loading = false;

  // Image's path
  String? imagePath;
  String? stylePath;
  String? generatedPath;

  // Get image file from generated image or original image
  File? get imageFile {
    if (generatedPath != null) {
      return File(generatedPath!);
    }

    if (imagePath != null) {
      return File(imagePath!);
    }

    return null;
  }

  Future<void> generateImage() async {
    if (imagePath != null && stylePath != null) {
      setState(() {
        loading = true;
      });

      final result = await styleTransfer.runStyleTransfer(
        styleImagePath: stylePath!,
        imagePath: imagePath!,
        styleFromAssets: true,
      );

      setState(() {
        loading = false;
        generatedPath = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Style Transfer'),
        actions: [
          if (generatedPath != null)
            IconButton(
              onPressed: () {
                Share.shareFiles(
                  [generatedPath!],
                );
              },
              icon: const Icon(
                Icons.share,
              ),
            )
        ],
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                if (imagePath != null)
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(imageFile!),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  stylePath = null;
                                  if (generatedPath != null) {
                                    generatedPath = null;
                                    stylePath = null;
                                  } else {
                                    imagePath = null;
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.cancel,
                                size: 32,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.photo,
                                size: 64,
                              ),
                            ],
                          ),
                          const Text('Take an image from camera or gallery')
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        imagePicker.pickImage(source: ImageSource.camera).then(
                          (value) {
                            setState(() {
                              imagePath = value?.path;
                              generatedPath = null;
                            });
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.camera,
                        size: 48,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        imagePicker.pickImage(source: ImageSource.gallery).then(
                          (value) {
                            setState(() {
                              imagePath = value?.path;
                              generatedPath = null;
                            });
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.photo,
                        size: 48,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 128,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: styleImages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  stylePath = null;
                                  generatedPath = null;
                                });
                              },
                              icon: const Icon(
                                Icons.do_not_disturb_alt_outlined,
                                size: 48,
                              ),
                            ),
                          ),
                        );
                      }

                      final style = styleImages[index - 1];

                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(4),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                if (imagePath != null) {
                                  setState(() {
                                    stylePath = style;
                                  });
                                  generateImage();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showMaterialBanner(
                                    MaterialBanner(
                                      content: const Text(
                                        'Take an image before set style',
                                      ),
                                      actions: [
                                        IconButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .clearMaterialBanners();
                                          },
                                          icon: const Icon(Icons.close),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    style,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (stylePath == style)
                            const Positioned(
                              right: 0,
                              child: Icon(
                                Icons.check_circle,
                                size: 32,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            if (loading)
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}
