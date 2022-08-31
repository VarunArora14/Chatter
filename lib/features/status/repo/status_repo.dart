import 'dart:developer';
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
import 'package:whatsapp_ui/features/status/models/status_model.dart';
import 'package:whatsapp_ui/models/user_model.dart';

// For other files to access this file, we use providers
final statusRepoProvider = Provider((ref) {
  // initialise these instances here rather than in constructor
  return StatusRepository(firestore: FirebaseFirestore.instance, ref: ref, auth: FirebaseAuth.instance);
});

class StatusRepository {
  final FirebaseFirestore firestore; // firestore instance for retrieving and saving data
  final FirebaseAuth auth; // to get the current user
  final ProviderRef ref;

  StatusRepository({
    required this.firestore,
    required this.ref,
    required this.auth,
  });

  /// method to upload image to firebase storage based on StatusModel for current user
  void uploadStatus(
      {required String username,
      required String phoneNumber,
      required String profilePic,
      required File statusImage, // the image user uploads from pickImageFromGallery()
      required BuildContext context}) async {
    // upload status to firebase storage and get the url of the image
    try {
      debugPrint('repo method of upload status started');
      var statusId = Uuid().v1(); // generate unique id for status based on time(v1)
      String userId = auth.currentUser!.uid; // get the current user id, cannot be null

      // now we have to store this pic to storage
      String newStatusUrl = await ref
          .read(commonFireBaseStorageRepoProvider)
          .storeFileToFirebase('/status/$statusId$userId', statusImage);
      // here the unique statusId will be the filename while others would be folders if not created
      // we use userId as name of the file bcos it's name(userId) will halp us to query the data below

      // now we get all user contacts and show status to those on our contact list only
      List<Contact> contacts = []; // can be nothing if no contacts

      if (await FlutterContacts.requestPermission()) {
        // request permission to access and if we get it then get all contacts
        contacts = await FlutterContacts.getContacts(withProperties: true); // stores all contacts in list
        // their properties are needed to show status to them
      }
      List<String> visibleContactsList = []; // list of contact ids who will see this status

      // loop through every contact and see if they are on our application database
      for (int i = 1; i < contacts.length; i++) {
        log('${contacts[i].displayName} : ${contacts[i].phones[0].number}');
      }

      debugPrint('contact loop ended');

      for (int i = 100; i < contacts.length; i++) {
        debugPrint('hello loop');
        var userDataDoc = await firestore
            .collection('users') // go to users collection and check if phone number matches with any in database
            .where(
              'phoneNumber', // 'where' clause/query to check if phone number matches with any in database
              isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''), // replace all spaces with empty string
            ) // for each contact[i] we use the phone[0] for main number and check the 'number' in firestore
            .get(); // get all the users who have this phone number
        debugPrint(userDataDoc.toString());
        if (userDataDoc.docs.isEmpty) {
          debugPrint('no user found');
        }
        // check if these docs are not empty and add user's contacts to visibleContactList
        if (userDataDoc.docs.isNotEmpty) {
          debugPrint(userDataDoc.docs[0].data().toString());
          var userData = UserModel.fromMap(userDataDoc.docs[0].data());
          // get the first doc and convert it to user model(although there should be only one doc)
          visibleContactsList.add(userData.userId); // add the user id to the list of visible contacts
        }
      }
      debugPrint('visible Contacts length is ${visibleContactsList.length}');

      List<String> statusImageUrls = []; // list to store image urls of all the photos user wants to post as status
      var statusSnapshots = await firestore
          .collection('status')
          .where('userId', isEqualTo: userId) // match filename for each status with userId
          // .where('createTime', isLessThan: DateTime.now().subtract(Duration(hours: 24)))
          .get(); // use 'createTime' as parameter tp show last 24 hour status only

//  It means user has 1 or more status already stored as mapped StatusModel objects in database
      if (statusSnapshots.docs.isNotEmpty) {
        // check if docs or document snapshot is not empty
        StatusModel status = StatusModel.fromMap(statusSnapshots.docs[0].data());
        statusImageUrls = status.photoUrlList; // get the list of photo urls from the previous status
        statusImageUrls.add(newStatusUrl); // add the new status image url to the list
        await firestore.collection('status').doc(statusSnapshots.docs[0].id).update(
          {
            // we update this to status id in status folder of firebase and not chats folder where we use userId
            'photoUrlList': statusImageUrls,
          }, // update the url list and update to map
        );
      } else {
        // this will be the first status of the user
        statusImageUrls = [newStatusUrl]; // add the new status image url to the EMPTY list of urls

        // create a new status model and upload this status to firebase
        StatusModel status = StatusModel(
          userId: userId, // current user id
          username: username, // name of user
          phoneNumber: phoneNumber,
          photoUrlList: statusImageUrls, // the list of photo urls(1 in this case)
          createTime: DateTime.now(), // current time taken as time of upload
          profilePic: profilePic, // url of profile pic
          statusId: statusId, // unique id for status based on time(v1)
          visibleContacts: visibleContactsList, // list of contacts who can see our status
        );

        await firestore.collection('status').doc(statusId).set(status.toMap()); // upload status to firebase
      }

      // match the userId named file with curren user Id initalized above
      // since statusId is a folder and userId is the name of the file, dont use userId and think u will get all
      // snapshots as it may lead to error
    } catch (e) {
      debugPrint(e.toString());
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
