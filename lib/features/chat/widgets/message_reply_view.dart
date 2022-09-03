// how the replied message is viewed
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enums.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/constants/colors.dart';
import 'package:whatsapp_ui/features/chat/widgets/display_message_card.dart';

class MessageReplyView extends ConsumerWidget {
  const MessageReplyView({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref) {
    // change state of messageProvider by calling state for StateNotifier
    ref.read(messageReplyProvider.state).update((state) => null); // update state where 'state' is prev state
    // null so that reply is cancelled and if cancelled we show nothing else show something
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider); // has the data of messageReplyProvider if not null
    // else we showed sizedbox in chat_list.dart
    return Container(
      decoration: BoxDecoration(
        color: tabColor.withOpacity(0.6),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      width: 280,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'You' : 'Friend',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () => cancelReply(ref), // we have to pass ref so arrow function can access it
                child: const Icon(
                  Icons.close,
                  size: 20,
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          DisplayMessageCard(messageData: messageReply.messageData, messageType: messageReply.messageType),
        ],
      ),
    );
  }
}
