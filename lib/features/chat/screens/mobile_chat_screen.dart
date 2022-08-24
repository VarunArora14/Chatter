import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/constants/colors.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/features/chat/widgets/chat_list.dart';

import '../widgets/bottom_chat_field.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  const MobileChatScreen({Key? key, required this.name, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 10,
        elevation: 0,
        backgroundColor: appBarColor,
        // any change in firebase auth state will trigger this method and pass the stream making easier than
        // sending requests each time
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          // get stream of user model using uid
          // pass AsyncSnapshot<UserModel> othewise it will consider values as dynamic
          builder: (context, snapshot) {
            debugPrint('the data is ${snapshot.data?.toMap().toString()}');
            // if connection is made, show the name of the user
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                const SizedBox(height: 8),
                Text(
                  snapshot.data!.isOnline ? 'Online' : 'Offline',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.white70),
                ),
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: ChatList(),
          ),
          const SizedBox(
            height: 1,
          ),
          BottomChatField(recieverId: uid), // pass uid of reciever contact as parameter
        ],
      ),
    );
  }
}




// Another thing we could have done instead of Streambuilder is to covert to ConsumerStatefulWidget and 
// use initstate and call .listen() method to get the stream but that would have been diff when we have 
// StreamBuilder which is a little bit more efficient to use.