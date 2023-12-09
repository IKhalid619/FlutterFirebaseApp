import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'controller/image_picker_controller.dart';
import 'package:lottie/lottie.dart';

class NotificationBottomNav extends StatefulWidget {
  const NotificationBottomNav({Key? key}) : super(key: key);

  @override
  State<NotificationBottomNav> createState() => _NotificationBottomNavState();
}

class _NotificationBottomNavState extends State<NotificationBottomNav> {
  final ImagePickerController controller = Get.put(ImagePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Gallery'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Container(
            child: Lottie.network('https://assets7.lottiefiles.com/packages/lf20_NODCLWy3iX.json'),
          ),
          const SizedBox(height: 20),
          const Text('Image Show', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.red)),
          ElevatedButton(
            onPressed: () async {
              await controller.pickImage();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // Background color
              onPrimary: Colors.white, // Text color
            ),
            child: const Text('Pick your Image'),
          ),

          Obx(() {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: controller.image.value?.path.isEmpty ?? true
                  ? Icon(Icons.camera, size: 50)
                  : Image.file(
                File(controller.image.value!.path),
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            );
          }),
          ElevatedButton(
            onPressed: () async {
              await controller.uploadImageToFirebase();
              // You might want to add a feedback mechanism here
              // For example, show a snackbar or update UI to indicate upload completion
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // Background color
              onPrimary: Colors.white, // Text color
            ),
            child: const Text('Upload to Firebase Storage'),
          ),

          Obx(() {
            if (controller.networkImage.value != null && controller.networkImage.value!.isNotEmpty) {
              return Image.network(controller.networkImage.value!);
            } else {
              return const SizedBox(); // Return an empty SizedBox if no image available yet
            }
          }),
        ],
      ),
    );
  }
}