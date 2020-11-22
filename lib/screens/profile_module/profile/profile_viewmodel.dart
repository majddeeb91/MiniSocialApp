import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_test/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_network_test/services/firestore_utils.dart';

class ProfileViewModel extends ChangeNotifier{
  bool isLoading = true;
  UserModel currentUser;

  void getProfileData() async{

    isLoading = true;
    notifyListeners();

    var fbaInstance = FirebaseAuth.instance;
    var currentUserUID = fbaInstance.currentUser.uid;
    currentUser = await FireStoreUtils().getCurrentUser(currentUserUID);


    isLoading = false;
    notifyListeners();


  }
}