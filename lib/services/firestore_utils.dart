import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_network_test/models/networking_response.dart';
import 'package:social_network_test/models/post_model.dart';
import 'package:social_network_test/models/user_model.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

class FireStoreUtils {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');
  Reference storage = FirebaseStorage.instance.ref();

  Future<UserModel> getCurrentUser(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      if (userDoc != null && userDoc.exists) {
        return UserModel.fromJson(userDoc.data());
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<FireStoreResponse> updateCurrentUser(UserModel user) async {
    return await firestore
        .collection('users')
        .doc(user.userID)
        .set(user.toJson())
        .then((document) {
      return FireStoreResponseData(user);
    }, onError: (e) {
      print(e);
      return FireStoreException('error while updating profile info');
    });
  }

  Future<FireStoreResponse> createPostInCloudFireStore(
      String text, File imageFile) async {
    try {
      CollectionReference postsCollection =
          FirebaseFirestore.instance.collection('posts');
      FirebaseAuth auth = FirebaseAuth.instance;
      String uid = auth.currentUser.uid;
      String postId = Uuid().v4();
      String imageURl = "";
      if (imageFile != null) {
        imageURl = await _uploadPostImageToFireStorage(imageFile, uid, postId);
      }
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      postsCollection.doc(postId).set({
        'post_id': postId,
        'owner_id': uid,
        'owner': userDoc.data(),
        'text': text,
        'image_url': imageURl,
        'creation_date': DateTime.now(),
        'is_liked': false,
        'liked_by': [],
      });
      return FireStoreResponseData(true);
    } catch (err) {
      print('error while creating post');
      return FireStoreException('error while creating post');
    }
  }

  Future<FireStoreResponse> getAllPostsFromCloudFireStore() async {
    List<PostModel> posts = [];
    try {
      CollectionReference postsCollection =
          FirebaseFirestore.instance.collection('posts');
      FirebaseAuth auth = FirebaseAuth.instance;
      String uid = auth.currentUser.uid;
      //String postId = Uuid().v4();
      await postsCollection
          .orderBy("creation_date", descending: true)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) async {
          // var owner =  await getCurrentUser(element['owner_id']);
          var post = PostModel.fromJson(element.data());
          post.isLiked = element['liked_by'].contains(uid);
          posts.add(post);
        });
      });
      /// add owner obejct form users collection to related post object
      for (var post in posts) {
       await getCurrentUser(post.ownerId).then((user) => {
         posts[posts.indexWhere((element) => element.ownerId == post.ownerId)].owner = user
       });
      }

      return FireStoreResponseData(posts);
    } catch (e) {
      print(e.toString());
      return FireStoreException(e.toString());
    }
  }

  Future<FireStoreResponse> likePostInCloudFireStore(String postId) async {
    try {
      CollectionReference postsCollection =
          FirebaseFirestore.instance.collection('posts');
      FirebaseAuth auth = FirebaseAuth.instance;
      String uid = auth.currentUser.uid;
      Future<DocumentSnapshot> postDocSnapShot =
          postsCollection.doc(postId).get();
      DocumentSnapshot postDoc = await postDocSnapShot;
      bool isLiked = postDoc["liked_by"].contains(uid);


      if (isLiked) {
        await postsCollection.doc(postId).update({
          "liked_by": FieldValue.arrayRemove([uid]),
        });
        return FireStoreResponseData(false);
      } else {
        await postsCollection.doc(postId).update({
          "liked_by": FieldValue.arrayUnion([uid]),
        });
        return FireStoreResponseData(true);
      }
    } catch (e) {
      print(e.toString());
      return FireStoreException('error while liking post');
    }
  }

  //******************************************** UPLOAD METHODS ********************************************************************************************************

  Future<FireStoreResponse> uploadUserImageToFireStorage(
      File image, String userId) async {
    try {
      String fileName = "users/$userId/" + basename(image.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      var downloadUrl = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();
      return FireStoreResponseData(downloadUrl.toString());
    } catch (e) {
      print(e.toString());
      return FireStoreException('error while uploading profile picture');
    }
  }

  Future<String> _uploadPostImageToFireStorage(
      File image, String userId, String postId) async {
    String fileName = "users/$userId/$postId/" + basename(image.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    return downloadUrl.toString();
  }
}

FireStoreUtils fireStoreUtilsInstacne = FireStoreUtils();

// await postsCollection.get().then((querySnapshot){
// querySnapshot.docs.forEach((postJson) async{
// await getCurrentUser(postJson['owner_id']).then((userModel) {
// var post = PostModel(
// text: postJson["text"],
// owner: userModel,//UserModel.fromJson(json["owner"]),
// creationDate: postJson['creation_date'].toDate(),
// imageUrl: postJson["image_url"],
// ownerId: postJson["owner_id"],
// postId: postJson["post_id"],
// //  isLiked: postJson["is_liked"],
// likers: List<Liker>.from(postJson["likers"].map((x) => Liker.fromJson(x))),
// );
// print("post");
// posts.add(post);
// });
//
// });
// });

// Future<FireStoreResponse> getAllPostsFromCloudFireStore() async {
//   List<PostModel> posts = [];
//   try {
//     CollectionReference postsCollection =
//     FirebaseFirestore.instance.collection('posts');
//     FirebaseAuth auth = FirebaseAuth.instance;
//     String uid = auth.currentUser.uid;
//     String postId = Uuid().v4();
// //foods[foods.indexWhere((element) => element.uid == food.uid)] = food;
//     await postsCollection
//         .orderBy("creation_date", descending: true)
//         .get()
//         .then((querySnapshot) {
//       querySnapshot.docs.forEach((element) async {
//         // var owner =  await getCurrentUser(element['owner_id']);
//         var post = PostModel.fromJson(element.data());
//         posts.add(post);
//       });
//     });
//
//     return FireStoreResponseData(posts);
//   } catch (e) {
//     print(e.toString());
//     return FireStoreException(e.toString());
//   }
// }
