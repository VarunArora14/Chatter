import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enums.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/chat/repo/chat_repo.dart';
import 'package:whatsapp_ui/models/chat_contact_model.dart';
import 'package:whatsapp_ui/models/message_model.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider); // watch the provider before calling method
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository; // use this chatrepo to call it's functions
  final ProviderRef ref; // interact with other providers for userDataProvider and replies

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  /// controller method to get contacts of current user displayed on contact_screen
  Stream<List<ChatContactModel>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  /// controller method to get reciever contactId to get the messages between current user and reciever
  Stream<List<MessageModel>> chatStream(String recieverContactId) {
    return chatRepository.getChatStream(recieverContactId);
  }

  /// controller method to send text message to the reciever via chatRepository
  void sendTextMessage(BuildContext context, String messageText, String recieverId) {
    // Here check if current message is a reply or not, ref from constructor to interact
    final messagReply = ref.read(messageReplyProvider); // ProviderRef used here to interact with other providers
    ref.read(userDataProvider).whenData(
          (value) => chatRepository.sendTextMessage(
              context: context,
              text: messageText,
              recieverId: recieverId,
              senderUser: value!,
              messageReply: messagReply),
        );
// we cannot get senderUser model which is Future from a screen so we use userDataProvider for that
// read from userDataProvider which watches authControllerProvider and returns user data
// the reason we use userDataProvider is because it is a FutureProvider and we want to return a Future
// and getUserData() returns a Future object so instead of async await we use FutureProvider
// plus the whenData() method is used when it has data(based on Future returned) and then we can send message based on that

// this is not a good way as this is future provider which calls firebase again and again
// Instead when we get data of user, we can use  StateNotifierProvider
  }

  /// controller method to send a file to the reciever via chatRepository
  void sendFileMessage(
    File file,
    BuildContext context,
    String recieverId,
    MessageEnum messageType,
  ) {
    // userDataProvider performs getUserData() which returnns a Future object and userDataProvider is a FutureProvider
    // Here check if current message is a reply or not, ref from constructor to interact
    final messagReply = ref.read(messageReplyProvider);
    ref.read(userDataProvider).whenData(
          (value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              recieverId: recieverId,
              senderModel:
                  value!, // it contains UserModel object invoked by getUserData() of Future provider above
              ref: ref, // interact with other providers, metioned in ChatController contructor
              messageType: messageType,
              messageReply: messagReply),
        );
  }

  /// controller method to send a gif to the reciever via chatRepository
  void sendGifMessage(BuildContext context, String gifUrl, String recieverId) {
    final messageReply = ref.read(messageReplyProvider); // read to see if current message is a reply or not
    int gifUrlEndIndex = gifUrl.lastIndexOf('-') + 1; // remove '-' from the end of the url
    String gifUrlEnd = gifUrl.substring(gifUrlEndIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlEnd/200.gif'; // combine the two parts of url

    ref.read(userDataProvider).whenData(
          (value) => chatRepository.sendGifMessage(
              context: context,
              gifUrl: newGifUrl,
              recieverId: recieverId,
              senderUser: value!,
              messageReply: messageReply),
        );
  }
  // convert the given gif  url to one which just shows gif
  // https://giphy.com/gifs/ohio-womens-equality-day-for-our-future-GreNzH1VnIWFPYDhpy -> gifUrl is this
  // https://i.giphy.com/media/GreNzH1VnIWFPYDhpy/200.gif -> this is what we want to show in the message
}
