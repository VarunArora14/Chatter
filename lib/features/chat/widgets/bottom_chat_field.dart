import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enums.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';

import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/features/chat/widgets/message_reply_view.dart';

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
  bool showSendButton = false; // to show send button when text is not empty
  bool isEmojiShowing = false; // true if emojiPicker is showing
  FocusNode focusNode = FocusNode(); // for focusing the text field

  void showKeyboard() => focusNode.requestFocus(); // request focus of keyboard to be shown
  void hideKeyboard() => focusNode.unfocus(); // request focus of keyboard to be hidden

  /// hides the emoji picker when the user taps outside of it
  void hideEmojiPicker() {
    setState(() {
      isEmojiShowing = false;
    });
  }

  /// shows the emoji picker when the user taps on the emoji button
  void showEmojiPicker() {
    setState(() {
      isEmojiShowing = true;
    });
  }

  /// based on isEmojiShowing, toggles whether the keyboard has to be shown or not
  void toggleKeyboard() {
    if (isEmojiShowing) {
      hideEmojiPicker();
      showKeyboard();
    } else {
      showEmojiPicker();
      hideKeyboard();
    }
  }

  /// send text message to the reciever and store to firebase and clear the text field
  void sendTextMessage() async {
    // async as time to read, create instances and then the function
    // check if message can be sent or not
    if (showSendButton == true) {
      // trim extra whitespaces after end
      ref.read(chatControllerProvider).sendTextMessage(context, _textController.text.trim(), widget.recieverId);
      ref.read(messageReplyProvider.state).update((state) => null); // clear the reply view
      setState(() {
        _textController.clear(); // clear the textfield after sending message
      });
    }
  }

  /// generic method for calling sendFileMessage() to send any file from sender to user based on messageType
  void sendFileMessage(
    File file,
    MessageEnum messageType,
  ) async {
    ref.read(chatControllerProvider).sendFileMessage(file, context, widget.recieverId, messageType);
    ref.read(messageReplyProvider.state).update((state) => null); // clear the reply view
  }

  /// select GIF and send GIF url and reciever id to controller method to send the GIF message from sender to reciever
  void selectGIF() async {
    final gif = await pickGIF(context); // show gif picker and select gif which can be null
    if (gif != null) {
      // ref.read(chatControllerProvider).sendGifMessage(gif, context, widget.recieverId);
      //  here we use the giphy url to view the gif rather than store it in firebase
      ref.read(chatControllerProvider).sendGifMessage(context, gif.url, widget.recieverId);
    }
  }

  /// method to select image form gallery when camera icon is clicked
  void selectImage() async {
    File? imageFile = await pickImageFromGallery(context); // context for snackbar
    if (imageFile != null) {
      sendFileMessage(imageFile, MessageEnum.image);
    }
  }

  /// method to select video from gallery when file icon is clicked
  void selectVideo() async {
    File? videoFile = await pickVideoFromGallery(context); // context for snackbar
    if (videoFile != null) {
      sendFileMessage(videoFile, MessageEnum.video);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isMessageReply = (messageReply != null); // check if messageReply null or not and based on that show it
    return Column(
      children: [
        // if messageReply is not null then show the messageReplyView
        isMessageReply
            ? const MessageReplyView()
            : const SizedBox(), // if messageReply is not null then show messageReplyView
        Row(
          children: [
            Expanded(
              // so textField does not take all the space
              child: TextField(
                focusNode: focusNode, // focus node for keyboard to decide whether to show or not
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
                            onPressed: toggleKeyboard, // toggles the keyboard based on isEmojiShowing
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.grey[600],
                            ),
                          ),
                          IconButton(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            constraints: const BoxConstraints(
                              minWidth: 0,
                            ),
                            onPressed: selectGIF, // select gif from giphy
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
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectImage, // choose image from gallery
                          constraints: const BoxConstraints(minWidth: 0),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          // padding: EdgeInsets.only(bottom: 10),
                          icon: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.grey[600],
                          ),
                        ),
                        IconButton(
                          onPressed: selectVideo, // choose video from gallery
                          padding: const EdgeInsets.only(left: 5),
                          constraints: const BoxConstraints(maxWidth: 38, minWidth: 38),
                          icon: Icon(
                            Icons.attach_file_rounded,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
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
                  // contentPadding: const EdgeInsets.all(10),
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
        ),
        isEmojiShowing
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      // add chosen emoji to the textfield
                      _textController.text +=
                          emoji.emoji; // emoji is a class and choose emoji and not name of emoji
                    });
                    // will be invoked if emoji selected
                    if (showSendButton == false) {
                      setState(() {
                        showSendButton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox(), // empty sizebox if keyboard showing
      ],
    );
  }
}
