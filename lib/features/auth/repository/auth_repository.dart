import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/repo/common_firebase_storage_repo.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_info_screen.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/screens/mobile_layout.dart';

// make sure we provide this AuthRepository class to Controller and that will interact with the screens
// for this we use riverpod package with global provier

// provider ref allows us to interact with other providers such as authControllerProvider and if we want to
// access this authRepositoryProvider we need to pass and use this ProviderRef
final authRepositoryProvider = Provider((ref) {
  return AuthRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
});

// AuthRepository is a class that will interact with the screens for this we use riverpod package with global provider
// it does not depend on firebase or firestore instance but rather takes them as constructor parameters
class AuthRepository {
  final FirebaseAuth auth; // for managing auth state and user data in firebase
  final FirebaseFirestore firestore;

  /// Get the current user data from Firestore database based on auth.currentUser and return UserModel object
  Future<UserModel?> getUserData() async {
    // this userData is in map format inserted in savaUserDataFirestore() method
    var userData = await firestore.collection('users').doc(auth.currentUser?.uid).get();
    // this uid is by firebase
    UserModel? user;
    // check if map not null
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!); // can be null
    }
    debugPrint('user data sent');
    return user;
  }

  AuthRepository({required this.auth, required this.firestore});

  /// Implement SignIn with phone number with verification and checks. This auth instance will later be used to get user
  ///  data from firestore database
  void signInWithPhone({required BuildContext context, required String phoneNumber}) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          // show error message if verification fails
          throw Exception(e.message);
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          // show OTP screen
          Navigator.pushNamed(context, OTPScreen.routeName, arguments: verificationId);
          // we can pass this as an argument to the OTP screen bcos of onGenerateRoute
        },
        codeAutoRetrievalTimeout: ((verificationId) {
          // means auto verification is timed out
          debugPrint(verificationId);
        }),
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, message: e.message!);
    }
    // for catch we could have simply used e.toString() instead of FireBaseAuthException but this is better
  }

  /// verify OTP using using PhoneCredential and signInWithCredential using FirebaseAuth instance
  void verifyOTP({required BuildContext context, required String verificationId, required String otp}) async {
    try {
      // we have to sign in with credentials while verifying otp and use PhoneAuthCredential as we use number
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      await auth.signInWithCredential(credential);
      // wait till auth instance verifies the user, function takes PhoneAuthCredential
      // as parameter and is async. If no error caught then user is signed in so push to next page
      Navigator.pushNamedAndRemoveUntil(context, UserInfoScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, message: e.message!);
    }
  }

  /// save user details in firestore database as UserModel class
  void saveUserDataFirestore(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      // ref to interact with commonFirebaseStorageRepo provider
      required BuildContext context}) async {
    // we need  ref to interact with other providers such as authControllerProvider
    try {
      String uid = auth.currentUser!.uid;
      // unique id for user whose profile pic and data will be uploaded
      String photoUrl = 'https://www.pngitem.com/pimgs/m/551-5510463_default-user-image-png-transparent-png.png';
      // storing as a default image file

      if (profilePic != null) {
        // first parameter is refpath or path to store the file in firebase storage using uid
        // as the unique profile pic for each user

        // this is the download url of the profile pic which we are overriding with the new profile pic
        photoUrl =
            await ref.read(commonFireBaseStorageRepoProvider).storeFileToFirebase('profilePic/$uid', profilePic);
      }

      var userModel = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: []);

      // now we put this UserModel as document in firestore database with uid as the document id in collection named as users
      await firestore.collection('users').doc(uid).set(userModel.toMap());

      // now move to the MobileScreen as signIn and verification is done
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => const MobileLayout()), (route) => false);
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }

  /// method to return stream of mapped User model of snapshot of a user based on their uid for async operations
  Stream<UserModel> userDataById(String userId) {
    // since stream returns stream whose snapshots are of type AsyncSnapshot, we dont have to specify the function as async or do await
    // it does it all automatially based on any change in snapshot
    // here we use snapshots as it return Stream of snapshots which is useful for getting online/offline status of user otherwise we have to send request to firebase everytime
    return firestore.collection('users').doc(userId).snapshots().map((event) => UserModel.fromMap(event.data()!));
    // from this snapshot, map the data passing even which is document<map<String,dynamic>> to UserModel class
    // it wont be null as we ask only when it is not null. ! means it cannot be null
  }

  // In case of Future<T> we have to send constant requests to get dome data whereas here we can use Stream<T> that asynchronously looks for changes
  // and returns a stream of data

  /// method ooto change the user's online status in firestore database
  void setUserState(bool isOnline) async {
    // change the value of isOnline field in firestore database and since access database so async
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline, // using name of field of map, assign the correct value to it
    });
  }
}

// this this info in firebase docs
// The UI will interact with Controller responsible for changing state of the UI and Controller
// will interact and send data to the Repository and Repository will interact with Firebase and Firestore
