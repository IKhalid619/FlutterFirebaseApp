import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  Rx<File?> image = File('').obs;
  Rx<String> networkImage = ''.obs;

  Future<void> pickImage() async {
    try {
      final imagePick = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (imagePick == null) {
        return; // Or handle the case when the imagePick is null
      }
      final imageTemp = File(imagePick.path);
      image.value = imageTemp;
    } on PlatformException catch (e) {
      // Handle or log the platform exception
      print('Error picking image: $e');
    } catch (e) {
      // Catch other exceptions if needed
      print('Unexpected error picking image: $e');
    }
  }

  Future<String> uploadImageToFirebase() async {
    if (image.value == null || image.value!.path.isEmpty) {
      return ''; // Handle case when image is null or path is empty
    }

    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    try {
      Reference reference =
      FirebaseStorage.instance.ref().child('mypicture/$fileName.png');
      await reference.putFile(image.value!);

      String downloadURL = await reference.getDownloadURL();
      networkImage.value = downloadURL;
      return downloadURL;
    } catch (e) {
      // Handle or log the Firebase Storage exception
      print('Error uploading image to Firebase: $e');
      return '';
    }
  }
}