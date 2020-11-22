import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:social_network_test/models/networking_response.dart';
import 'package:social_network_test/models/user_model.dart';
import 'package:social_network_test/services/firestore_utils.dart';
import 'package:social_network_test/utils/helper.dart';

class EditProfileViewModel {

  Future<FireStoreResponse> updateProfileData(UserModel user, BuildContext context)async{

    showProgress(context, "Loading..", false);

    FireStoreResponse fireStoreResponse =  await fireStoreUtilsInstacne.updateCurrentUser(user);

    if (fireStoreResponse is FireStoreResponseData) {
        UserModel user =  fireStoreResponse.responseDataModel;
        hideProgress();
        return fireStoreResponse;
    } else if (fireStoreResponse is FireStoreException) {

      print(fireStoreResponse.message);
      hideProgress();
      return fireStoreResponse;
    }


  }

  Future<FireStoreResponse> uploadProfilePicture(File imageFile, String userId, BuildContext context) async{

    showProgress(context, "Loading..", false);

    FireStoreResponse fireStoreResponse =  await fireStoreUtilsInstacne.uploadUserImageToFireStorage(imageFile,userId);

    if (fireStoreResponse is FireStoreResponseData) {
      String imageUrl =  fireStoreResponse.responseDataModel;
      hideProgress();
      return fireStoreResponse;
    } else if (fireStoreResponse is FireStoreException) {
      /// show error msg on the screen
      print(fireStoreResponse.message);
      hideProgress();
      return fireStoreResponse;
    }

  }


}


EditProfileViewModel editProfileViewModel = EditProfileViewModel();
