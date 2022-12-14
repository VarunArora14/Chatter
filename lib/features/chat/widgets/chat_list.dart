import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/common/enums/message_enums.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
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

  /// changes state of message reply provider by returning a new instance of MessageReply used for reply view
  void onMessageSwipe(String message, bool isMe, MessageEnum messageType) {
    ref.read(messageReplyProvider.notifier).update((state) => MessageReply(message, isMe, messageType));
    // on swipe, change the state of messageReplyProvider an return MessageReply class instance
    // when we swipe we change the state of messageReplyProvider and it will be updated
    // https://riverpod.dev/docs/providers/state_provider/
  }

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
// if message is not seen and reciever is US then we have to say the message is seen
// since this is defined inside this builder then we can see for each message if it is seen or not based on below condition
                if (!messageData.isSeen && messageData.recieverId == FirebaseAuth.instance.currentUser!.uid) {
                  ref
                      .read(chatControllerProvider)
                      .setChatMessageSeen(context, widget.recieverContactId, messageData.messageId);
                }
                if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
                  // check if sender of user is FireBase current user then send MyMessageCard
                  return MyMessageCard(
                    message: messageData.messageText, // array[] cannot be bull
                    date: timeSent,
                    messageType: messageData.messageType,
                    replyText: messageData.replyMessageText, // this will be stored in MessageModel class
                    replyUser: messageData.repliedUser,
                    replyMessageType: messageData.replyMessageType,
                    onLeftSwipe: () => onMessageSwipe(
                      // method on this message card which takes the text of
                      messageData.messageText, // this message, it's type and isMe for the current message
                      true, // to show this message as replied message to and then the current message
                      messageData.messageType,
                    ),
                    isSeen: messageData.isSeen, // based on this decide whether to show the blue tick or not
                    // since senderId same as auth.uid then we are replying to our message, pass the data to onMessageSwipe
                  );
                }
                return SenderMessageCard(
                  message: messageData.messageText,
                  date: timeSent,
                  messageType: messageData.messageType,
                  replyText: messageData.replyMessageText, // this will be stored in MessageModel class
                  replyUser: messageData.repliedUser,
                  replyMessageType: messageData.replyMessageType,
                  onRightSwipe: () => onMessageSwipe(
                    messageData.messageText,
                    false, // reply to other dude
                    messageData.messageType,
                  ),
                );
              },
            );
          }
          return const ErrorPage(errortext: 'Chat_list.dart ambigous error');
        });
  }
}
