// we dont need class as  return type is future so we can simply use FutureProvider
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_ui/features/select_contacts/repository/select_contact_repository.dart';

// use FutureProvider as we want to return a future and using ref.watch we can get the future which we can return to the screens
final getContactProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getData();
});

// provide instance of this class
final selectedContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return SelectedContactController(
      ref: ref, selectContactRepository: selectContactRepository);
});

class SelectedContactController {
  final ProviderRef ref; // used to interact with other providers
  final SelectContactRepository selectContactRepository;

  SelectedContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  void selectContact(BuildContext context, Contact selectedContact) async {
    selectContactRepository.selectContact(context, selectedContact);
  }
}
