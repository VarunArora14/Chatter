import 'dart:io';
import 'dart:async';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

/// picks Image and returns a Future file object if chosen
Future<File?> pickImageFromGallery(BuildContext context) async {
  File? imageFile;
  try {
    final chosenImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (chosenImage != null) {
      imageFile = File(chosenImage.path); // convert xfile to type File
    }
  } catch (e) {
    showSnackBar(context: context, message: e.toString());
  }
  return imageFile;
}

/// pick video from gallery
Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? videoFile;
  try {
    final chosenVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (chosenVideo != null) {
      videoFile = File(chosenVideo.path); // convert xfile to type File
    }
  } catch (e) {
    showSnackBar(context: context, message: e.toString());
  }
  return videoFile;
}

/// return a Future gif from gif picker which can be nothing if no gif is chosen
Future<GiphyGif?> pickGIF(BuildContext context) async {
  // API key from giphy dev
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(context: context, apiKey: "aLevRHlcDsa22c4PsxAwU2pNPFrIpWFF");
  } catch (e) {
    showSnackBar(context: context, message: e.toString());
  }
  return gif; // can be null
}
