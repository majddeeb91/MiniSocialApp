import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_network_test/models/networking_response.dart';
import 'package:social_network_test/models/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'firestore_utils.dart';

class AuthService {
  final fbAuth.FirebaseAuth _auth = fbAuth.FirebaseAuth.instance;
  final _fireStoreUtils = FireStoreUtils();

  ///auth change user stream
  Stream<fbAuth.User> get authUserStream {
    return _auth.authStateChanges();
  }

  Future<FireStoreResponse> signInWithGoogle() async {
    try {
      final googleSignInAccount = await GoogleSignIn().signIn();
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final authResult = await _auth.signInWithCredential(credential);
      final authUser = authResult.user;
      final currentUser = await _auth.currentUser;
      assert(authUser.uid == currentUser.uid);

      UserModel user =
          await _fireStoreUtils.getCurrentUser(authResult.user.uid);
      //check if google user is existed in firestore or not to avoid recreating it
      if (user == null) {
        FireStoreResponse reponseData =
            await _createUserInFireStoreFromGoogleSignIn(
                googleSignInAuthentication, authUser.uid);
        return reponseData;
      } else {
        // here we should sync with existing account
        FireStoreResponse responseData = FireStoreResponseData((user));
        return responseData;
      }
    } catch (e) {
      return FireStoreException(e.toString());
    }
  }

  Future<FireStoreResponse> _createUserInFireStoreFromGoogleSignIn(
      GoogleSignInAuthentication googleSignInAuthentication, String uid) async {
    try {
      final token = googleSignInAuthentication.accessToken;
      final response = await http.get(
          'https://www.googleapis.com/oauth2/v3/userinfo?access_token=$token');
      final profile = json.decode(response.body);
      UserModel user = UserModel(
        firstName: profile['given_name'],
        lastName: profile['family_name'],
        dob: DateTime.now(),
        email: profile['email'],
        profilePictureURL: profile['picture'],
        description: "I came from google",
        userID: uid,
      );
      var res = await FireStoreUtils.firestore
          .collection('users')
          .doc(uid)
          .set(user.toJson());
      return FireStoreResponseData(user);
        // WrapperState.currentUser = user;

        //hideProgress();
        // pushAndRemoveUntil(context, HomeScreen(user: user), false);

    } catch (e) {
      return FireStoreException(e.toString());
    }
  }

// login with Facebook
  Future<FireStoreResponse> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        return FireStoreException("Could not login via facebook.");
        break;
      case FacebookLoginStatus.loggedIn:
        final credential =
            fbAuth.FacebookAuthProvider.credential(result.accessToken.token);
        final authResult = await _auth.signInWithCredential(credential);
        UserModel user = await _fireStoreUtils.getCurrentUser(authResult.user.uid);

        /// if user is not exist in firestore then create it
        if (user == null) {
          var res = await _createUserInFireStoreFromFacebookLogin(result, authResult.user.uid);

            if (res is FireStoreResponseData) {
              return FireStoreResponseData(res.responseDataModel);
            } else {
              /// error while creating user in firestore
              return FireStoreException('Could not login via facebook.');
            }

        }

        else {
          /// here we can resync data with the fb account
          return FireStoreResponseData(user);
          //_syncUserDataWithFacebookData(result, user);
        }
        break;
      default :
        return null;
    }
    return null;
  }

  Future<FireStoreResponse> _createUserInFireStoreFromFacebookLogin(
      FacebookLoginResult result, String userID) async {
    try {
      final token = result.accessToken.token;
      final graphResponse = await http.get('https://graph.facebook.com/v2'
          '.12/me?fields=name,first_name,last_name,email,picture.type(large)&access_token=$token');
      final profile = json.decode(graphResponse.body);
      UserModel user = UserModel(
          firstName: profile['first_name'],
          lastName: profile['last_name'],
          dob: DateTime.now(),
          email: profile['email'],
          description: 'I came from facebook',
          profilePictureURL: profile['picture']['data']['url'],
          userID: userID);
      await FireStoreUtils.firestore
          .collection('users')
          .doc(userID)
          .set(user.toJson())
          .then((onValue) {
        // WrapperState.currentUser = user;
        //hideProgress();
        // pushAndRemoveUntil(context, HomeScreen(user: user), false);
      });
      return FireStoreResponseData(user);
    } catch (e) {
      print(e.toString());
      return FireStoreException('Could not login via facebook.');
    }
  }

  //login with email and password
  Future<FireStoreResponse> signInWithEmailAndPassword(
      String email, String password) async {
    var _auth = FirebaseAuth.instance;
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;

      if (user != null) {
        return FireStoreResponseData(user);
      } else {
        return FireStoreException("error while login by email and password");
      }
    } catch (e) {
      return FireStoreException(e.toString());
    }
  }

  // SignUp With email and Password
  Future<FireStoreResponse> registerWithEmailAndPassword(String firstName, String lastName, String email, String password) async {
    var uuid = Uuid();
    try {
      print(email);
      var userCredential = await fbAuth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var returnedUser = userCredential.user;

      if (returnedUser != null) {
        UserModel user = UserModel(
            firstName: firstName,
            lastName: lastName,
            email: email,
            dob: DateTime.now(),
            description: '',
            profilePictureURL:
                'http://www.gravatar.com/avatar/3b3be63a4c2a439b013787725dfce802?d=mp',
            userID: returnedUser.uid);
        await FireStoreUtils.firestore
            .collection('users')
            .doc(returnedUser.uid)
            .set(user.toJson())
            .then((value) {
          // WrapperState.currentUser = user;
          //hideProgress();
          // pushAndRemoveUntil(context, HomeScreen(user: user), false);

          return FireStoreResponseData(user);
        });
      } else {
        return FireStoreException('error while registering user');
      }
    } catch (e) {
      print(e.toString());
      return FireStoreException(e.toString());
    }
  }

  //logout
  Future<FireStoreResponse> logout() async {
    try {
      var _auth = FirebaseAuth.instance;
      _auth.signOut();
      return FireStoreResponseData(null);
    } catch (error) {
      print(error.toString());
      return FireStoreException('error while sign out');
    }
  }
}

AuthService authService = AuthService();


//   void _syncUserDataWithFacebookData(FacebookLoginResult result,
//       User user) async {
//     final token = result.accessToken.token;
//     final graphResponse = await http.get('https://graph.facebook.com/v2'
//         '.12/me?fields=name,first_name,last_name,email,picture.type(large)&access_token=$token');
//     final profile = json.decode(graphResponse.body);
//     user.profilePictureURL = profile['picture']['data']['url'];
//     user.firstName = profile['first_name'];
//     user.lastName = profile['last_name'];
//     user.email = profile['email'];
//     user.active = true;
//     await _fireStoreUtils.updateCurrentUser(user, context);
//     MyAppState.currentUser = user;
//     hideProgress();
//     pushAndRemoveUntil(context, HomeScreen(user: user), false);
//   }
// }
