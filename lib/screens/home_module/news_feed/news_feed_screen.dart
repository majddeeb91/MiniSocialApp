import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_test/constants.dart';
import 'package:social_network_test/screens/home_module/create_post/create_post_screen.dart';
import 'package:social_network_test/screens/home_module/news_feed/local_widgets/body.dart';
import 'package:social_network_test/screens/home_module/news_feed/news_feed_viewmodel.dart';
import 'package:social_network_test/screens/profile_module/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:social_network_test/services/auth.dart';

class NewsFeedScreen extends StatelessWidget {
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: buildAppBar(context),
          body: Body(),
        );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: IconButton(
        icon: Icon(Icons.person),
        color: kPrimaryLightColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileScreen()));

        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          color: kPrimaryLightColor,
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => CreatePostScreen()));
          },
        ),
        IconButton(
          icon: Icon(Icons.logout),
          color: kPrimaryLightColor,
          onPressed: () async{
           Provider.of<NewsFeedViewModel>(context,listen: false).logout(context);
          }
        ),
      ],
    );
  }
}
