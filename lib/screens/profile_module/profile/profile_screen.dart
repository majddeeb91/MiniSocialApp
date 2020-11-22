import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_test/constants.dart';
import 'package:social_network_test/models/user_model.dart';
import 'package:social_network_test/screens/profile_module/edit_profile/edit_profile_screen.dart';
import 'package:social_network_test/screens/profile_module/profile/local_widgets/body.dart';
import 'package:social_network_test/screens/profile_module/profile/profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
     Provider.of<ProfileViewModel>(context, listen: false).getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: kPrimaryLightColor,
            onPressed: () async {
              UserModel user =
                  Provider.of<ProfileViewModel>(context, listen: false)
                      .currentUser;
              if (user != null) {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                              commingUser: user,
                            ))).then((value) => {
                      Provider.of<ProfileViewModel>(context, listen: false)
                          .getProfileData()
                    });
              }
            },
          ),
        ],
      ),
      body: Body(),
    );
  }
}
