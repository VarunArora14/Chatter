// Based on the messageType, it decides what widget to display.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/enums/message_enums.dart';
// use cached_network_image package to cache the images and display rather than making calls everytime
// it is much better for storing images/files which have to be loaded again and again

class DisplayMessageCard extends StatelessWidget {
  final String messageData; // url of uploaded file or text message
  final MessageEnum messageType; // based on which we will decide how to show the file

  const DisplayMessageCard({
    Key? key,
    required this.messageData,
    required this.messageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return messageType == MessageEnum.text
        ? Text(
            messageData,
            style: const TextStyle(fontSize: 16),
          )
        : CachedNetworkImage(imageUrl: messageData);
    // assuming there can be only 2 types of messages - text and image right now
  }
}
