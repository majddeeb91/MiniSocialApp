import 'package:flutter/cupertino.dart';
import 'package:social_network_test/models/networking_response.dart';
import 'dart:io';
import 'package:social_network_test/services/firestore_utils.dart';
import 'package:social_network_test/utils/helper.dart';

class CreatePostViewModel {
  Future createPost(String text, File imageFile, BuildContext context) async {
    showProgress(context, "Loading ..", false);

    await fireStoreUtilsInstacne
        .createPostInCloudFireStore(text, imageFile)
        .then((fireStoreResponse) {
      if (fireStoreResponse is FireStoreResponseData) {
        Future.delayed(Duration(seconds: 1))
            .then((value) => hideProgress())
            .then((value) => Navigator.pop(context));
      } else if (fireStoreResponse is FireStoreException) {
        Future.delayed(Duration(seconds: 1))
            .then((value) => hideProgress())
            .then((value) =>
                showAlertDialog(context, "Alert", fireStoreResponse.message));
      }
    });
  }
}

CreatePostViewModel createPostViewModelInstance = CreatePostViewModel();
