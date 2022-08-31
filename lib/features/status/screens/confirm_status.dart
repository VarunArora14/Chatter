// transition screen to decide whether we want to use this image as status or not as confirmation
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/constants/colors.dart';
import 'package:whatsapp_ui/features/status/controller/status_controller.dart';
import 'package:whatsapp_ui/screens/mobile_layout.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const routeName = '/confirm_status';
  final File file; // the file must not be null at this point
  const ConfirmStatusScreen({Key? key, required this.file}) : super(key: key);

  void addStatus(WidgetRef ref, BuildContext context) {
    debugPrint('confirm status screen button pressed');
    // pass the file to the controller to upload it to firebase
    ref.read(statusControllerProvider).addStatus(context, file);
    // remove the prev screens
    Navigator.pop(context);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => const MobileLayout()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        // aspct ratio here matters and show the image here and use Image.file to show the image
        child: AspectRatio(aspectRatio: 9 / 16, child: Image.file(file)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addStatus(ref, context),
        backgroundColor: tabColor,
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}
