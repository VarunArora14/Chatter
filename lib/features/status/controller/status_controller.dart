import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/status/models/status_model.dart';

import 'package:whatsapp_ui/features/status/repo/status_repo.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepo = ref.watch(statusRepoProvider); // watch for any changes in statusRepoProvider
  return StatusController(ref: ref, statusRepo: statusRepo);
});

class StatusController {
  final StatusRepository statusRepo; // to get the data from the repo
  final ProviderRef ref; // to interact with other providers

  StatusController({required this.ref, required this.statusRepo});

  /// controller method to get upload status to firebase via statusRepoProvider
  void addStatus(BuildContext context, File statusImage) async {
    debugPrint('controller method of add status');
    // get user data using Future provider to get the name, profilePic and phoneNumber
    ref.watch(userDataProvider).whenData((value) {
      return statusRepo.uploadStatus(
          username: value!.name,
          phoneNumber: value.phoneNumber,
          profilePic: value.profilePic,
          statusImage: statusImage,
          context: context);
    });
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> statuses = await ref.read(statusRepoProvider).getStatus(context);
    return statuses;
  }
}
