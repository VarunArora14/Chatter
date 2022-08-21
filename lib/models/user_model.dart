class UserModel {
  final String name; // name of user
  final String uid; // unique id of user
  final String profilePic; // the url of the pic and not file
  final bool isOnline; // is user online or not
  final String phoneNumber; // phone number of user
  final List<String> groupId; // Id's of groups user is in

  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }

  // Encoding and Decoding data is easier unlike node where string->map->model and reverse was used
}
