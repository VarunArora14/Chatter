import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/repo/common_firebase_storage_repo.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/models/user_model.dart';

class StatusRepository {
  final FirebaseFirestore firestore; // firestore instance for retrieving and saving data
  final FirebaseAuth auth; // to get the current user
  final ProviderRef ref;

  StatusRepository({
    required this.firestore,
    required this.ref,
    required this.auth,
  });

  void uploadStatus(
      {required String username,
      required String phoneNumber,
      required String profileUrl,
      required File statusImage, // the image user uploads from pickImageFromGallery()
      required BuildContext context}) async {
    // upload status to firebase storage and get the url of the image
    try {
      var statusId = Uuid().v1(); // generate unique id for status based on time(v1)
      String userId = auth.currentUser!.uid; // get the current user id, cannot be null

      // now we have to store this pic to storage
      String statusUrl = await ref
          .read(commonFireBaseStorageRepoProvider)
          .storeFileToFirebase('/status/$userId/$statusId', statusImage);
      // here the unique statusId will be the filename while others would be folders if not created

      // now we get all user contacts and show status to those on our contact list only
      List<Contact> contacts = []; // can be nothing if no contacts

      if (await FlutterContacts.requestPermission()) {
        // request permission to access and if we get it then get all contacts
        contacts = await FlutterContacts.getContacts(withProperties: true);
        // their properties are needed to show status to them
      }
      List<String> visiblecontactId = []; // list of contact ids who will see this status

      // loop through every contact and see if they are on our application database
      for (int i = 0; i < contacts.length; i++) {
        var userDataDoc = await firestore
            .collection('users') // go to users collection and check if phone number matches with any in database
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''), // replace all spaces with empty string
            ) // for each contact[i] we use the phone[0] for main number and check the 'number' in firestore
            .get(); // get all the users who have this phone number

        // check if these docs are not empty
        if (userDataDoc.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataDoc.docs[0].data());
          // get the first doc and convert it to user model(although there should be only one doc)
          visiblecontactId.add(userData.uid); // add the user id to the list of visible contacts
        }
      }

      List<String> statusImageUrls = [];
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }

// we want to upload status so follow these steps - 1. The status uploaded by us should be visible to only our
// contacts so add those contacts to a list, check if our contacts phNo matches users in current user's contact list
// Check if status already exists add image to list of existing images else add the only image of status
// Create a status model
}

// FirebaseAuth is for user authentication and authorisation
// FirebaseStorage is for uploading and downloading files(take url and render the image)
// FirebaseFirestore is for storing and retrieving data from firebase
