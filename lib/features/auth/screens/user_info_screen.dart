import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  static const routeName = '/user-info-screen';
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final usernameController = TextEditingController();
  File? image;
  // based on this file value we will decide whether we have to show default image or chosen

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
  }

  void selectImage() async {
    File? chosenImage = await pickImageFromGallery(context);
    if (chosenImage != null) {
      image = chosenImage;
    }
    setState(() {});
  }

  void storeUserData() async {
    String name = usernameController.text.trim();
    if (name.isEmpty) {
      // to use ref, we have to convert stateful widget to ConsumerStateful widget
      showSnackBar(context: context, message: 'Enter valid name');
      return;
    }
    // ref is global provider we access through flutter_riverpod package
    ref.read(authControllerProvider).saveUserDataFirestore(context, name, image);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
            // here we want an icon to choose an image over which user can select profileImage
            child: Column(
          children: [
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(
                            'https://www.pngitem.com/pimgs/m/551-5510463_default-user-image-png-transparent-png.png'),
                      )
                    : CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(image!), // can be nullable though we have a check
                      ),
                Positioned(
                  bottom: 10,
                  left: 120,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo_rounded, color: Colors.white70),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(hintText: 'Please enter  your name'),
                  ),
                ),
                IconButton(
                  // todo: add functionality to save the user image
                  onPressed: storeUserData,
                  icon: Icon(Icons.done, color: Colors.greenAccent[400]),
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}
