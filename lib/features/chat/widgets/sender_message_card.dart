import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsapp_ui/common/enums/message_enums.dart';
import 'package:whatsapp_ui/constants/colors.dart';

import 'display_message_card.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum messageType;
  final VoidCallback onRightSwipe; // when right swipe other's msg then reply box will be updated
  final String replyText; // the text which we are replying to be used for reply view
  final String replyUser; // user to whome we are replying
  final MessageEnum replyMessageType; // type of message we are replying to

  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageType,
    required this.onRightSwipe,
    required this.replyText,
    required this.replyUser,
    required this.replyMessageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      // wrap with SwipeTo for handling right swiper here from plugin
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: messageType == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 10,
                          right: 30,
                          top: 5,
                          bottom: 20,
                        )
                      : const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 5,
                          bottom: 25,
                        ),
                  child: DisplayMessageCard(
                    messageData: message, // pass the message whether text or url of uploaded file
                    messageType: messageType, // and type based on which we decide how to show the file
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
