import 'package:whatsapp_ui/common/enums/message_enums.dart';

class MessageModel {
  final String senderId;
  final String recieverId;
  final String messageText;
  final DateTime timeSent;
  final bool isSeen;
  final MessageEnum messageType;
  final String messageId;
  final String replyMessageText; // text which we are replying to
  final String repliedUser; // user to whom we are replying
  final MessageEnum replyMessageType; // type of message we are replying to

  MessageModel({
    required this.senderId,
    required this.recieverId,
    required this.messageText,
    required this.timeSent,
    required this.isSeen,
    required this.messageType,
    required this.messageId,
    required this.replyMessageText,
    required this.repliedUser,
    required this.replyMessageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverId': recieverId,
      'messageText': messageText,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'isSeen': isSeen,
      'messageType': messageType.type, // store the string and retrieve same later making it enum
      'messageId': messageId,
      'replyMessageText': replyMessageText,
      'repliedUser': repliedUser,
      'replyMessageType': replyMessageType.type, // same as above num change and below conversion
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] ?? '',
      recieverId: map['recieverId'] ?? '',
      messageText: map['messageText'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      isSeen: map['isSeen'] ?? false,
      messageType: (map['messageType'] as String).toEnum(), // convert to enum
      messageId: map['messageId'] ?? '',
      replyMessageText: map['replyMessageText'] ?? '',
      repliedUser: map['repliedUser'] ?? '',
      replyMessageType: (map['replyMessageType'] as String).toEnum(),
      // take the string and use toEnum() to convert to enum
    );
  }
}

// forgot to add enum type to firebase, also use map['messageType'] and not map['type'] based on model