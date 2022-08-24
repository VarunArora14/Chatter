import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/common/widgets/error_page.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';

import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/info.dart';
import 'package:whatsapp_ui/models/message_model.dart';
import 'package:whatsapp_ui/widgets/my_message_card.dart';
import 'package:whatsapp_ui/widgets/sender_message_card.dart';

class ChatList extends ConsumerWidget {
  final String recieverContactId;
  const ChatList({
    Key? key,
    required this.recieverContactId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<MessageModel>>(
        // define the stream builder type(List<MessageModel>) for length for snapshot
        stream: ref.read(chatControllerProvider).chatStream(recieverContactId), // read
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
            return const Loader();
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messageData = snapshot.data![index]; // use this variable at places instead of snapshot
                var timeSent = DateFormat.Hm().format(messageData.timeSent);
                if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
                  // check if sender of user is FireBase current user then send MyMessageCard
                  return MyMessageCard(
                    message: messageData.messageText, // array[] cannot be bull
                    date: timeSent,
                  );
                }
                return SenderMessageCard(
                  message: messageData.messageText,
                  date: timeSent,
                );
              },
            );
          }
          return const ErrorPage(errortext: 'Chat_list.dart ambigous error');
        });
  }
}
