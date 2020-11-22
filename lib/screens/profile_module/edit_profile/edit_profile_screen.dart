import 'package:flutter/material.dart';
import 'package:social_network_test/constants.dart';
import 'package:social_network_test/models/user_model.dart';
import 'package:social_network_test/screens/profile_module/edit_profile/local_wigets/body.dart';

class EditProfileScreen extends StatelessWidget {
  final UserModel commingUser;

  const EditProfileScreen({Key key, this.commingUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      body: Body(commingUser: commingUser) ,
    );
  }
}
