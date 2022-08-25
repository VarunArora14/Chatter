import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enums.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';

import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';

// Convert to stateful for icon changing and state changes of just this BottomField and not whole screen
class BottomChatField extends ConsumerStatefulWidget {
  final String recieverId;
  const BottomChatField({
    Key? key,
    required this.recieverId,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final _textController = TextEditingController();
  bool showSendButton = false;

  /// send text message to the reciever and store to firebase and clear the text field
  void sendTextMessage() async {
    // async as time to read, create instances and then the function
    // check if message can be sent or not
    if (showSendButton == true) {
      // trim extra whitespaces after end
      ref.read(chatControllerProvider).sendTextMessage(context, _textController.text.trim(), widget.recieverId);
      setState(() {
        _textController.clear(); // clear the textfield after sending message
      });
    }
  }

  /// generic method for calling sendFileMessage() to send any file from sender to user based on messageType
  void chooseFileMessage(
    File file,
    MessageEnum messageType,
  ) async {
    ref.read(chatControllerProvider).sendFileMessage(file, context, widget.recieverId, messageType);
  }

  void selectImage() async {
    File? imageFile = await pickImageFromGallery(context); // context for snackbar
    if (imageFile != null) {
      chooseFileMessage(imageFile, MessageEnum.image);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          // so textField does not take all the space
          child: TextField(
            controller: _textController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                showSendButton = true;
              } else {
                showSendButton = false;
              }
              setState(() {});
            },
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Message here',
              hintStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: const Color.fromARGB(244, 235, 231, 231),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  width: 80,
                  child: Row(
                    children: [
                      IconButton(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        constraints: const BoxConstraints(maxWidth: 40, minWidth: 30),
                        // splashRadius: 10,
                        onPressed: () {},
                        icon: Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey[600],
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                        icon: Icon(
                          Icons.gif_rounded,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      // padding: EdgeInsets.only(bottom: 10),
                      icon: GestureDetector(
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      constraints: const BoxConstraints(maxWidth: 38, minWidth: 38),
                      icon: Icon(
                        Icons.attach_file_rounded,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 2, 8),
          child: CircleAvatar(
              backgroundColor: const Color(0xFF128C7E),
              radius: 25,
              child: GestureDetector(
                onTap: sendTextMessage,
                child: Icon(
                  showSendButton == true ? Icons.send : Icons.keyboard_voice_rounded,
                  color: Colors.white,
                ),
              )),
        )
      ],
    );
  }
}
