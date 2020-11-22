import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_test/screens/profile_module/profile/profile_viewmodel.dart';
import 'package:social_network_test/utils/helper.dart';
import 'package:social_network_test/widgets/background.dart';
//Consumer<NewsFeedViewModel>(builder: (context, viewmodel, child) {
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(builder: (context, viewmodel, child) {
    return Background(
      child: SingleChildScrollView(
        child: viewmodel.isLoading ? CircularProgressIndicator() : Column (
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage:
              NetworkImage(viewmodel.currentUser.profilePictureURL),
            ),
            Text(
              viewmodel.currentUser.fullName(),
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4,
            ),
            Text(viewmodel.currentUser.email,
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle1),
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            Text(formatterDateTime(viewmodel.currentUser.dob), style: Theme
                .of(context)
                .textTheme
                .subtitle1),
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            Text(viewmodel.currentUser.description, style: Theme
                .of(context)
                .textTheme
                .subtitle1),
          ],
        ),
      ),
    );
  });
  }
}
