import 'package:whatsapp_ui/common/enums/message_enums.dart';

class MessageModel {
  final String senderId;
  final String recieverId;
  final String messageText;
  final DateTime timeSent;
  final bool isSeen;
  final MessageEnum messageType;
  final String messageId;

  MessageModel({
    required this.senderId,
    required this.recieverId,
    required this.messageText,
    required this.timeSent,
    required this.isSeen,
    required this.messageType,
    required this.messageId,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverId': recieverId,
      'messageText': messageText,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'isSeen': isSeen,
      'messageType': messageType.type, // check messages_enum where we have this type for string value of enum
      'messageId': messageId,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] ?? '',
      recieverId: map['recieverId'] ?? '',
      messageText: map['messageText'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      isSeen: map['isSeen'] ?? false,
      messageType: (map['messageType'] as String).toEnum(), // stored as string, called when get data from firebase
      messageId: map['messageId'] ?? '',
    );
  }
}

// forgot to add enum type to firebase, also use map['messageType'] and not map['type'] based on model