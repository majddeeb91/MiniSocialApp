import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_test/screens/auth_module/login/login_screen.dart';
import 'package:social_network_test/screens/home_module/news_feed/news_feed_screen.dart';

class Wrapper extends StatefulWidget {
  @override
  WrapperState createState() => WrapperState();
}

class WrapperState extends State<Wrapper> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // hasFinishedWrapping();
  }

  @override
  Widget build(BuildContext context) {
    var fbaInstance = FirebaseAuth.instance;
    if (fbaInstance.currentUser != null){
      return NewsFeedScreen();
    }
    else{
      return LoginScreen();
    }

    // User fbUser = Provider.of<User>(context);
    // if (fbUser == null) {
    //   return LoginScreen();
    // } else {
    //   return NewsFeedScreen();
    // }
  }
}
