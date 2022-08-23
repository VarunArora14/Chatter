import 'package:flutter/material.dart';
import 'package:whatsapp_ui/constants/colors.dart';

// Convert to stateful for icon changing and state changes of just this BottomField and not whole screen
class BottomChatField extends StatefulWidget {
  const BottomChatField({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final textController = TextEditingController();
  Icon bottomIcon = const Icon(
    Icons.keyboard_voice,
    color: Colors.white,
  );
  bool showSendButton = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          // so textField does not take all the space
          child: TextField(
            controller: textController,
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
                        constraints:
                            const BoxConstraints(maxWidth: 40, minWidth: 30),
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
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.grey[600],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      constraints:
                          const BoxConstraints(maxWidth: 38, minWidth: 38),
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
            child: showSendButton
                ? IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ))
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.keyboard_voice_rounded,
                      color: Colors.white,
                    )),
          ),
        )
      ],
    );
  }
}
