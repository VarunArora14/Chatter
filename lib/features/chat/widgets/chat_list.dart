import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/common/widgets/error_page.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp_ui/models/message_model.dart';

import 'my_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverContactId;
  const ChatList({
    Key? key,
    required this.recieverContactId,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  // create ScrollController here not above
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        // define the stream builder type(List<MessageModel>) for length for snapshot
        stream: ref.read(chatControllerProvider).chatStream(widget.recieverContactId), // read
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
            return const Loader();
          }

          // if stream rebuilds with new message then scroll down
          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.animateTo(scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
            // scroll jump to maximum where you can scroll down to(the last message), add this to scrollable
            // item such as listview builder
          });

          if (snapshot.hasData) {
            return ListView.builder(
              controller: scrollController, // goes to newest message when it arrives
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messageData = snapshot.data![index]; // use this variable at places instead of snapshot
                var timeSent = DateFormat.Hm().format(messageData.timeSent);
                if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
                  // check if sender of user is FireBase current user then send MyMessageCard
                  return MyMessageCard(
                    message: messageData.messageText, // array[] cannot be bull
                    date: timeSent,
                    messageType: messageData.messageType,
                  );
                }
                return SenderMessageCard(
                  message: messageData.messageText,
                  date: timeSent,
                  messageType: messageData.messageType,
                );
              },
            );
          }
          return const ErrorPage(errortext: 'Chat_list.dart ambigous error');
        });
  }
}
