import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_test/models/networking_response.dart';
import 'package:social_network_test/models/user_model.dart';
import 'package:social_network_test/screens/home_module/news_feed/news_feed_screen.dart';
import 'package:social_network_test/services/auth.dart';
import 'package:social_network_test/utils/helper.dart';

class LoginViewModel {
  void signInWithGoogle(BuildContext context) async {
    /// show loader
    showProgress(context, "loggingIn..", false);

    /// wait for response
    FireStoreResponse fireStoreResponse = await authService.signInWithGoogle();

    /// We check the type of response and update the required field
    if (fireStoreResponse is FireStoreResponseData) {
      if (fireStoreResponse != null) {
       // UserModel user = fireStoreResponse.responseDataModel;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewsFeedScreen()));
      }
    } else if (fireStoreResponse is FireStoreException) {
      /// show error msg on the screen
      print(fireStoreResponse.message);
    }

    /// Stop the loader
    Future.delayed(Duration(seconds: 1))
        .then((value) => {progressDialog.hide()});
  }

  void signInWithFacebook(BuildContext context) async {
    /// show loader
    showProgress(context, "loggingIn..", true);

    /// wait for response
   // FireStoreResponse fireStoreResponse =
        await authService.signInWithFacebook().then((fireStoreResponse) {
          /// We check the type of response and update the required field
          if (fireStoreResponse is FireStoreResponseData) {
              // UserModel user = fireStoreResponse.responseDataModel;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewsFeedScreen()));

          } else if (fireStoreResponse is FireStoreException) {
            /// show error msg on the screen
            print(fireStoreResponse.message);
          }

        });



    /// Stop the loader
    Future.delayed(Duration(seconds: 1))
        .then((value) => {progressDialog.hide()});
  }

  void signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {

    showProgress(context, "loggingIn..", true);

    /// wait for response
    FireStoreResponse fireStoreResponse =
        await authService.signInWithEmailAndPassword(email, password);

    Future.delayed(Duration(seconds: 1))
        .then((value) => {progressDialog.hide()});

    /// We check the type of response and update the required field
    if (fireStoreResponse is FireStoreResponseData) {
     // UserModel user = fireStoreResponse.responseDataModel;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewsFeedScreen()));
    } else if (fireStoreResponse is FireStoreException) {
      /// show error msg on the scree
      print(fireStoreResponse.message);
      Future.delayed(Duration(seconds: 1)).then((value) {
            progressDialog.hide().then((value) =>
                showAlertDialog(context, "Alert", fireStoreResponse.message));
          });
    }
  }
}

LoginViewModel loginViewModelInstance = LoginViewModel();
