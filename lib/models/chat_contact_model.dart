class ChatContactModel {
  final String name;
  final String profilePic;
  final DateTime timeSent;
  final String contactId;
  final String lastMessage;

  ChatContactModel({
    required this.name,
    required this.profilePic,
    required this.timeSent,
    required this.contactId,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'contactId': contactId,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      contactId: map['contactId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
    );
  }

// removed toJson() as firebase does it easily for us
}
