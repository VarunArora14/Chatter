import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// to provide this class to other classes we use riverpod package with global provider
// we use this provider ref to access this class and return instance of this class
final commonFireBaseStorageRepoProvider = Provider((ref) {
  return CommonFireBaseStorageRepo(firebaseStorage: FirebaseStorage.instance);
  // creating instance of this FirebaseStorage class when this provider called through ref
});

class CommonFireBaseStorageRepo {
  final FirebaseStorage firebaseStorage;
  CommonFireBaseStorageRepo({
    required this.firebaseStorage,
  });

  /// Using path to upload image and file, it uploads the image to firebase storage and returns the url of the image
  Future<String> storeFileToFirebase(String refpath, File file) async {
// we communicate with firebase storage path and we use ref for path accessing in Firebase storage
// we use ref for path accessing in Firebase storage
    UploadTask uploadTask = firebaseStorage.ref().child(refpath).putFile(file);
// upload this to firebase storage and get download url later
    TaskSnapshot taskSnapshot =
        await uploadTask; // wait till uploading of file is done
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
