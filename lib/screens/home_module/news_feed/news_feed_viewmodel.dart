import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_test/models/networking_response.dart';
import 'package:social_network_test/models/post_model.dart';
import 'package:social_network_test/screens/auth_module/login/login_screen.dart';
import 'package:social_network_test/services/auth.dart';
import 'package:social_network_test/services/firestore_utils.dart';
import 'package:social_network_test/utils/helper.dart';

class NewsFeedViewModel extends ChangeNotifier {
  bool isLoading = true;
  List<PostModel> posts = [];

  NewsFeedViewModel() {
    isLoading = true;
    getAllPosts();

    ///listening for posts collection changes and reflect the change on screen
    fireStoreUtilsInstacne.postsCollection.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        print(change);
        getAllPostsWithoutLoading();
      });
    });
    //getAllPosts();
  }

  void getAllPosts() async {
    /// Start showing the loader
    isLoading = true;
    notifyListeners();

    /// wait for response
    FireStoreResponse fireStoreResponse =
        await fireStoreUtilsInstacne.getAllPostsFromCloudFireStore();

    /// We check the type of response and update the required field
    if (fireStoreResponse is FireStoreResponseData) {
      if (fireStoreResponse != null) {
        posts = fireStoreResponse.responseDataModel;
      }
    } else if (fireStoreResponse is FireStoreException) {
      /// show error msg on the screen
      print(fireStoreResponse.message);
    }

    /// Stop the loader
    isLoading = false;
    notifyListeners();
  }

  void getAllPostsWithoutLoading() async {
    /// Start showing the loader

    /// wait for response
    FireStoreResponse fireStoreResponse =
        await fireStoreUtilsInstacne.getAllPostsFromCloudFireStore();

    /// We check the type of response and update the required field
    if (fireStoreResponse is FireStoreResponseData) {
      if (fireStoreResponse != null) {
        posts = fireStoreResponse.responseDataModel;
      }
    } else if (fireStoreResponse is FireStoreException) {
      /// show error msg on the screen
      print(fireStoreResponse.message);
    }

    /// Stop the loader
    isLoading = false;
    notifyListeners();
  }

  void likePost(String postId) async {
    var result = await fireStoreUtilsInstacne.likePostInCloudFireStore(postId);
  }

  void logout(BuildContext context) async {
    await authService.logout().then((fireStoreResponse) {
      if (fireStoreResponse is FireStoreResponseData) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      } else if (fireStoreResponse is FireStoreException) {
        showAlertDialog(context, "Alert", fireStoreResponse.message);
      }
    });
  }
}
