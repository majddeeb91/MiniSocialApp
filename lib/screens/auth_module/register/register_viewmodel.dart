

import 'package:flutter/material.dart';
import 'package:social_network_test/models/networking_response.dart';
import 'package:social_network_test/models/user_model.dart';
import 'package:social_network_test/services/auth.dart';
import 'package:social_network_test/utils/helper.dart';

class RegisterViewModel {
  Future<FireStoreResponse> register(String firstName, String lastName, String email, String password,BuildContext context) async {

    showProgress(context, "Loading..", false);

    /// wait for response
    FireStoreResponse fireStoreResponse =  await authService.registerWithEmailAndPassword(firstName, lastName, email, password);

    Future.delayed(Duration(seconds: 1))
        .then((value) => {progressDialog.hide()});
    /// We check the type of response and update the required field
    if (fireStoreResponse is FireStoreResponseData) {
      return fireStoreResponse;
    } else if (fireStoreResponse is FireStoreException) {
      /// show error msg on the screen
      print(fireStoreResponse.message);
      return fireStoreResponse;
    }

  }
}

RegisterViewModel registerViewModelInstance = RegisterViewModel();