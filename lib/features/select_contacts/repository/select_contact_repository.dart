// based on this repository file we will have our UI as we want to show contacts based on user contact list
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider((ref) {
  return SelectContactRepository(firestore: FirebaseFirestore.instance);
  // create instance of FirebaseFirestore class on
});

class SelectContactRepository {
  final FirebaseFirestore firestore;
  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getData() async {
    List<Contact> contacts = [], phoneContacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        // if this withProperties is not true then selectedContact.phone[0].number will be null or empty string
        contacts = await FlutterContacts.getContacts(withProperties: true);
        for (var contact in contacts) {
          // add only those contacts which have phone number
          if (contact.phones.isNotEmpty) {
            phoneContacts.add(contact);
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return phoneContacts;
  }

  /// method for selecting reciever contact and checking if contact in database and based on that take to their chat screen or show snackbar error
  void selectContact(BuildContext context, Contact selectedRecieverContact) async {
    try {
      // check if current Contact phoneNuber matches with any in database
      var userCollection = await firestore.collection('users').get();
      // get all the users from database bcos Users.findById doesnt exist here
      bool isFound = false;

      for (var document in userCollection.docs) {
        // each document in docs is a user
        var userMap = document.data(); // this has the map of user
        var userData = UserModel.fromMap(userMap); // convert map to UserModel
        // user phone number stored as +{country code}{phone number} with no spaces
        String selectedNumber =
            selectedRecieverContact.phones[0].number.replaceAll(' ', ''); // replace all spaces with empty string
        debugPrint(selectedNumber);

        if (selectedNumber == userData.phoneNumber) {
          isFound = true;
// number found from all contacts so navigate to chat screen. here we  pass arguments to chat screen for current user uid nd their profile pic
          Navigator.pushNamed(context, MobileChatScreen.routeName,
              arguments: {'name': userData.name, 'uid': userData.uid}); // recieve these  arguments in router.dart
        }

        // check for not found number
        if (!isFound) {
          showSnackBar(context: context, message: 'This number does not exist on this app');
        }
      }
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }
}
