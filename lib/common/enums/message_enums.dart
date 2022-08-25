enum MessageEnum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const MessageEnum(this.type);
  final String type;
}

// make sure we convert this enum to String as that will be considered and
// make sure these can be converted back from string to num

// we can do using 2 ways -
// 1. Using extension(which is what we will do, other you can search)
// 2. Use enhanced enums

// syntax for extension taking string and based on string val, return the enum. 'this' means current string chosen
extension MessageEnumExtension on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'image':
        return MessageEnum.image;
      case 'audio':
        return MessageEnum.audio;
      case 'video':
        return MessageEnum.video;
      case 'text':
        return MessageEnum.text;
      case 'gif':
        return MessageEnum.gif;
      default:
        return MessageEnum.text;
    }
  }
}
