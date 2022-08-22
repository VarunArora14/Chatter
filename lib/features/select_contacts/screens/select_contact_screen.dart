import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/error_page.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/select_contacts/controller/select_contact_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/select_contact';
  const SelectContactScreen({Key? key}) : super(key: key);

  void selectContact(
      BuildContext context, Contact selectedContact, WidgetRef ref) {
    ref
        .read(selectedContactControllerProvider)
        .selectContact(context, selectedContact);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: ref.watch(getContactProvider).when(
          data: (contactList) => ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (BuildContext context, int index) {
                  final contact = contactList[index];
                  return InkWell(
                    // read the contact controller and call the function to select the contact
                    onTap: () => selectContact(context, contact, ref),
                    child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(fontSize: 17),
                        ),
                        leading: contact.photo == null
                            ? null
                            : CircleAvatar(
                                backgroundImage: MemoryImage(contact.photo!),
                                radius: 30,
                              )),
                  );
                },
              ),
          error: (error, stackTrace) {
            return ErrorPage(errortext: error.toString());
          },
          loading: () => const Loader()),
    );
  }
}
