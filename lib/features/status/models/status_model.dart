class StatusModel {
  final String userId; // the id of the user who is posting the status
  final String username; // his name
  final String phoneNumber; // his phone number
  final List<String> photoUrlList; // list of urls of photos he wants to post as status
  final DateTime createTime; // time when the status was created(last one probably)
  final String profilePic; // profilePic of current user as image url
  final String statusId; // the id for each status pic
  final List<String> visibleContacts; // contacts who can see the status
  StatusModel({
    required this.userId,
    required this.username,
    required this.phoneNumber,
    required this.photoUrlList,
    required this.createTime,
    required this.profilePic,
    required this.statusId,
    required this.visibleContacts,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrlList': photoUrlList,
      'createTime': createTime.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'visibleContacts': visibleContacts,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrlList: List<String>.from(map['photoUrlList']),
      createTime: DateTime.fromMillisecondsSinceEpoch(map['createTime']),
      profilePic: map['profilePic'] ?? '',
      statusId: map['statusId'] ?? '',
      visibleContacts: List<String>.from(map['visibleContacts']),
    );
  }
}
