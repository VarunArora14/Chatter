import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/enums/message_enums.dart';
import 'package:whatsapp_ui/constants/colors.dart';
import 'package:whatsapp_ui/features/chat/widgets/display_message_card.dart';

class MyMessageCard extends StatelessWidget {
  final String message; // it will be of type url for anything not text enum
  final String date;
  final MessageEnum messageType; // based on which we will decide how to show the file

  const MyMessageCard({Key? key, required this.message, required this.date, required this.messageType})
      : super(key: key);

  EdgeInsets setPadding(String message, MessageEnum messageType) {
    if (messageType == MessageEnum.text && message.length < 4) {
      return const EdgeInsets.only(
        left: 35,
        right: 30,
        top: 5,
        bottom: 20,
      );
    } else if (messageType == MessageEnum.text && message.length >= 4) {
      return const EdgeInsets.only(
        left: 10,
        right: 30,
        top: 5,
        bottom: 20,
      );
    } else {
      return const EdgeInsets.only(
        left: 5,
        right: 5,
        top: 5,
        bottom: 5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: setPadding(message, messageType),
                child: DisplayMessageCard(
                  messageData: message, // pass the message whether text or url of uploaded file
                  messageType: messageType, // and type based on which we decide how to show the file
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.done_all,
                      size: 20,
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
