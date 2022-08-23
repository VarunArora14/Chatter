import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/constants/colors.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/info.dart';
import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_ui/models/chat_contact_model.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContactModel>>(
          stream: ref.watch(chatControllerProvider).getChatContacts(), // watch the chat provider and then method()
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length, // use snapshot which is type List<ChatContactModel> and not null
              itemBuilder: (context, index) {
                // chatContact of type ChatContactModel so see it's fromMap() method to access it's properties
                var chatContact = snapshot.data![index]; // array cannot be null so use !
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, MobileChatScreen.routeName,
                            arguments: {'name': chatContact.name, 'uid': chatContact.contactId});
                        // pass the arguments which is name and Id of person whose chat will be opened
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            chatContact.name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              chatContact.lastMessage,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              chatContact.profilePic,
                            ),
                            radius: 30,
                          ),
                          trailing: Text(
                            DateFormat.Hm().format(chatContact.timeSent), // format date from string using intl
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: dividerColor, indent: 85),
                  ],
                );
              },
            );
          }),
    );
  }
}
