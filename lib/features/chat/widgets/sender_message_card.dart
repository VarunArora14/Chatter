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

  EdgeInsets setPadding(String message, MessageEnum messageType) {
    if (messageType == MessageEnum.text && message.length < 4 && replyText.isNotEmpty) {
      return const EdgeInsets.only(
        left: 10,
        right: 30,
        top: 5,
        bottom: 30,
      );
    } else if (messageType == MessageEnum.text && message.length < 4) {
      return const EdgeInsets.only(
        left: 35,
        right: 30,
        top: 5,
        bottom: 30,
      );
    } else if (messageType == MessageEnum.text && message.length >= 4) {
      return const EdgeInsets.only(
        left: 10,
        right: 30,
        top: 5,
        bottom: 30,
      );
    } else {
      return const EdgeInsets.only(
        left: 5,
        right: 5,
        top: 5,
        bottom: 10,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReplying = replyText.isNotEmpty; // if reply text is not empty then we are replying
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
                  padding: setPadding(message, messageType),
                  child: Column(
                    children: [
                      // show a message card, name text above current message if we are replying to any message
                      if (isReplying) ...[
                        // cascade operator otherwise we can only show text and not the reply text
                        // https://stackoverflow.com/questions/53359109/dart-how-to-truncate-string-and-add-ellipsis-after-character-number
                        // todo: If string too big then use above
                        Text(
                          replyUser,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: DisplayMessageCard(
                            messageData: replyText,
                            messageType: replyMessageType,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      DisplayMessageCard(
                        messageData: message, // pass the message whether text or url of uploaded file
                        messageType: messageType, // and type based on which we decide how to show the file
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4,
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
