// Based on the messageType, it decides what widget to display.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/enums/message_enums.dart';
import 'package:whatsapp_ui/features/chat/widgets/video_player_item.dart';
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

  Widget currentMessage(String messageData, MessageEnum messageType) {
    switch (messageType) {
      case MessageEnum.text:
        return Text(
          messageData,
          style: const TextStyle(fontSize: 16),
        );
      case MessageEnum.image:
        return Padding(
            // network image as it has the imge here has firebase url as messageData which we try to cache and show
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(height: 250, child: CachedNetworkImage(imageUrl: messageData)));
      case MessageEnum.video:
        return VideoPlayerWidget(videoUrl: messageData); // here messageData will be url sent by firebase
      case MessageEnum.gif:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: CachedNetworkImage(imageUrl: messageData),
        ); // works same for gif as image
      default:
        return Text(
          messageData,
          style: const TextStyle(fontSize: 16),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return currentMessage(messageData, messageType);
    // assuming there can be only 2 types of messages - text and image right now
  }
}
