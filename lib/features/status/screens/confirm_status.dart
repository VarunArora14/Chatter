// transition screen to decide whether we want to use this image as status or not as confirmation
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/constants/colors.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const routeName = '/confirm_status';
  final File file; // the file must not be null at this point
  const ConfirmStatusScreen({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        // aspct ratio here matters and show the image here and use Image.file to show the image
        child: AspectRatio(aspectRatio: 9 / 16, child: Image.file(file)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: tabColor,
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}
