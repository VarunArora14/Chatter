import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/enums/message_enums.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/chat_contact_model.dart';
import 'package:whatsapp_ui/models/message_model.dart';
import 'package:whatsapp_ui/models/user_model.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
  // return their own instance of the class rather than taking them as constructor parameters/ class dependencies
});

class ChatRepository {
  // authorise the user and get the chat from firestore
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  /// private method accesible from sendTextMessage() to display new messages on top of screen for both sender and receiver
  void _saveDataToContactSubcollection(
      UserModel sender, UserModel reciever, String messageText, DateTime timeSent) async {
    // for new message, we need to to send 2 requests, first for reciever to get chats and set data in StreamBuilder like below
    // users ->  reciever user id -> chats -> sender id -> set data(for viewing last message on top of contact_screen)
    var recieverContact = ChatContactModel(
        name: sender.name,
        profilePic: sender.profilePic,
        timeSent: timeSent,
        contactId: sender.uid,
        lastMessage: messageText); // view last message on contact_screen to show latest messages on top of screen

    await firestore
        .collection('users')
        .doc(reciever.uid) // store this data in reciever id
        .collection('chats') // have collection named chats for each reciever
        .doc(sender.uid) // have a document for each user by their senderId
        .set(recieverContact.toMap()); // save to reciever's collection converting to map

    // then do same for sender user id
    // users -> sender user id -> chats ->reciever id -> set data(for viewing last message on top of contact_screen)
    // do reverse of above for sender
    var senderContact = ChatContactModel(
        name: reciever.name,
        profilePic: reciever.profilePic,
        timeSent: timeSent,
        contactId: reciever.uid,
        lastMessage: messageText); // send this contact model to collection

    await firestore
        .collection('users')
        .doc(sender.uid) // save to current user doc
        .collection('chats') // have chats collection for sender
        .doc(reciever.uid) // document for chat from sender to reciever
        .set(senderContact.toMap()); // send mapped data to collection

    // this receiverContact and senderContact  map will contain the last sent message and time sent of that msg
  }

  /// save messages sent by sender to message subcollection of the reciever's 'messages' collection through
  ///  firestore using messages model class
  void _saveMessageToMessageSubcollection(
      {required String messageText,
      required String recieverId,
      required String senderName,
      required String recieverName,
      required DateTime timeSent,
      required String messageId,
      required MessageEnum messageType}) async {
    // for each message we need to save to message subcollection based on the message model we created
    final message = MessageModel(
        senderId: auth.currentUser!.uid, // current user and senderUser in below func will point to same senderid
        recieverId: recieverId,
        messageText: messageText,
        timeSent: timeSent,
        isSeen: false, // change value based  on logic
        messageType: messageType,
        messageId: messageId);

    // do the below 2 times as we need to show stuff for both users
    // users -> senderUserId -> messages -> receiverUserId -> messages collection -> messageId -> store message
    await firestore
        .collection('users') // common collection for all users
        .doc(auth.currentUser!.uid) // in the document of current user or senderId(same thing)
        .collection('chats') // access the chats collection
        .doc(recieverId) // and access the recieverId for accessing chats with recieverId
        .collection('messages') // this collection has the messages btw sender and reciever
        .doc(messageId) // store message in this random generated messageId
        .set(message.toMap()); // map the message to map and save to collection

    // users -> recieverUserId -> messages/chats -> senderUserId  -> messages collection -> messageId -> store message

    await firestore
        .collection('users')
        .doc(recieverId) // this time we store this data in reciever so they can see it on their screen
        .collection('chats') // collection name for messages
        .doc(auth.currentUser!.uid) // document for sender as being viewed by reciever
        .collection('messages') // collection for messages inside chats for each user reciever chats to
        .doc(messageId) // store message in this random generated messageId
        .set(message.toMap());
  }

  /// send text message of current user to the other user while storing in firestore
  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverId,
      required UserModel senderUser}) async {
    // we want more of sender than just id
    // The chat

    try {
      var timeSent = DateTime.now(); // get the time when message is sent
      UserModel receiverUserData; // get the receiver user data using recieverid

      var userDataMap = await firestore.collection('users').doc(recieverId).get();
      // get map of reciever
      receiverUserData = UserModel.fromMap(userDataMap.data()!); // can be null

      var messageId = const Uuid().v1(); // generate random message id based on time
      _saveDataToContactSubcollection(senderUser, receiverUserData, text, timeSent);

      // after data is saved to contact subcollection, we need to store it to message subcollection

      _saveMessageToMessageSubcollection(
          messageText: text,
          recieverId: recieverId,
          senderName: senderUser.name,
          recieverName: receiverUserData.name,
          timeSent: timeSent,
          messageId: messageId,
          messageType: MessageEnum.text);
    } catch (e) {
      showSnackBar(context: context, message: 'Send text message failed: ${e.toString()}');
    }
  }

  // this function cannot be tested bcos we use buildcontext here and then display errors, If we used Future<String>
  // and if string was returned if success or not then we can test this function
}

// Since there can be multiple users of same sender, we need to get the recieverUserId to send the message
// Since message is 2 sided in terms that reciever also has the messages stored
// in its chat collection, we need to get the reciever user model as well

// For sendTextMessage() understand the following -
/*
save in 2 collections 1. show the last message on top of contact_screen using StreamBuilder

    users ->  reciever user id -> chats -> set data(for viewing last message on top of contact_screen)
    If we dont have chats collection then we will have problem managing messages for each user as top
    message will be different for each user

    2. save the message in message Collection
    collection would be stored as users -> senderUserId -> receiverUserId -> messages -> messageId -> store message
*/
