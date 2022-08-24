// It's task is to call AuthRepository file and if input formatting reqired and do that.
// we want noth classes AuthRepository AuthController to be independent of any dependency so we take Firebase
// and Firestore as constructor parameters along with AuthRepository in this case
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_ui/models/user_model.dart';

// All providers are global and have to be global

// this providerdoes 2 things, watch authRepositoryProvider and if it changes then call this provider
// and returns AuthController object taking authRepositoryProvider as constructor parameter along with ref
final authControllerProvider = Provider((ref) {
  // to avoid passing AuthRepository as a constructor parameter we use riverpod package
  final authRepository = ref.watch(authRepositoryProvider); // will return AuthRepository instance

  // ref.watch is equivalent of Provider.of<TypeName>(context)
  return AuthController(authRepository: authRepository, ref: ref); // this ref is ProviderRef and not WidgetRef
  // as we want this to passed in saveUserDataFirestore() method
});

final userDataProvider = FutureProvider((ref) {
  // here we wnt to return  authController user data and we cant use normal provider as getUserData() returns Future
  // so we use FutureProvider. We first watch() the authControllerProvider and then we get the user data from authController
  final userDataController = ref.watch(authControllerProvider);
  return userDataController.getUserData();
  // we use this controller to get user data for persistence

  // Benefit of usign FutureProvider(of riverpod) is that it identifies the getUserData() method returns a future
  // and so it is easier than configuring Provider to return a future.
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  /// controller method for getting user data from firestore database by passing this to authRepository
  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getUserData();
    return user;
  }

  /// this controller method will be called from the login screen to send phone number to AuthRepository
  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context: context, phoneNumber: phoneNumber);
  }

  /// controller method to send verify otp request to AuthRepository
  void verifyOTP(BuildContext context, String verificationId, String otp) {
    authRepository.verifyOTP(context: context, verificationId: verificationId, otp: otp);
  }

  // bind the authRepository to the controller of saveUserData so that we can make controller interact
  // with screen while authRepository is not directly interacting with screen

  /// this controller method binds the authRepository to the controller of saveUserData so that we can make
  ///  controller interact with Screen while authRepository is not directly interacting with Screen
  void saveUserDataFirestore(BuildContext context, String name, File? profilePic) {
    authRepository.saveUserDataFirestore(name: name, profilePic: profilePic, ref: ref, context: context);
  }
  // IMP: if we call this function in a widget, it provides use with WidgetRef but here we want ProviderRef
  // so we take this from our class as contructor parameter
  // we want provider of other file to interact with this provider here for saveUserDataFirestore
  // and not interact with widget

  /// controller method for calling userData from authRepository which returns Stream of UserModel for async
  ///  operations
  Stream<UserModel> userDataById(String userId) {
    return authRepository.userDataById(userId);
  }

  /// controller method to change user's online/offline status
  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline); // no return as void function
  }
}
// this controller will pass to the LoginScreen so we have to make sure it's instance available to the LoginScreen
// we have to make sure this authController is used on LoginScreen when user clicks on sign in with phone button

// Riverpod catches error at compile time rather than runtime which is time saver for development
// it makes code more testable and depedency injection is easy to use
