import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enums.dart';

class MessageReply {
  final String messageData; // message to whom we are replying to
  final bool isMe; // reply to self or other
  final MessageEnum messageType; // enum of message we have to reply to

  MessageReply(this.messageData, this.isMe,
      this.messageType); // type of message - text, image, video, gif we are replying to
}

// we cant use normal provider as we dont know what the messageData has, could be url or text
// We use StateProvider by which we can change the state of Provider and it will be updated whenever we this provider

final messageReplyProvider = StateProvider<MessageReply?>((ref) {
  return;
});
