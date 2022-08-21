// It's task is to call AuthRepository file and if input formatting reqired and do that.
// we want noth classes AuthRepository AuthController to be independent of any dependency so we take Firebase
// and Firestore as constructor parameters along with AuthRepository in this case
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';

// All providers are global and have to be global

final authControllerProvider = Provider((ref) {
  // to avoid passing AuthRepository as a constructor parameter we use riverpod package
  final authRepository =
      ref.watch(authRepositoryProvider); // will return AuthRepository instance

  // ref.watch is equivalent of Provider.of<TypeName>(context)
  return AuthController(
      authRepository: authRepository,
      ref: ref); // this ref is ProviderRef and not WidgetRef
  // as we want this to passed in saveUserDataFirestore() method
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  /// this controller method will be called from the login screen to send phone number to AuthRepository
  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context: context, phoneNumber: phoneNumber);
  }

  /// controller method to send verify otp request to AuthRepository
  void verifyOTP(BuildContext context, String verificationId, String otp) {
    authRepository.verifyOTP(
        context: context, verificationId: verificationId, otp: otp);
  }

  // bind the authRepository to the controller of saveUserData so that we can make controller interact
  // with screen while authRepository is not directly interacting with screen

  /// this controller method binds the authRepository to the controller of saveUserData so that we can make controller interact with Screen while authRepository is not directly interacting with Screen
  void saveUserDataFirestore(
      BuildContext context, String name, File? profilePic) {
    // we call this function in a widget and provides use with Widget ref but here we want ProviderRef
    // so we take this from our class as contructor parameter
    authRepository.saveUserDataFirestore(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }
}
// this controller will pass to the LoginScreen so we have to make sure it's instance available to the LoginScreen
// we have to make sure this authController is used on LoginScreen when user clicks on sign in with phone button

// Riverpod catches error at compile time rather than runtime which is time saver for development
// it makes code more testable and depedency injection is easy to use
