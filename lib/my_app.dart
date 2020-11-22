import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_test/screens/home_module/news_feed/news_feed_viewmodel.dart';
import 'package:social_network_test/screens/profile_module/profile/profile_viewmodel.dart';
import 'package:social_network_test/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';


class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<NewsFeedViewModel>(
                  create: (context) => NewsFeedViewModel()),
              ChangeNotifierProvider<ProfileViewModel>(
                  create: (context) => ProfileViewModel()),
            ],
            child: MaterialApp(
              home: Wrapper(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          home: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}






// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<EditProfileViewModel>(
//             create: (context) => EditProfileViewModel()),
//         ChangeNotifierProvider<NewsFeedViewModel>(
//             create: (context) => NewsFeedViewModel()),
//         ChangeNotifierProvider<ProfileViewModel>(
//             create: (context) => ProfileViewModel()),
//       ],
//       child: StreamProvider<User>.value(
//         value: authService.authUserStream,
//         child: MaterialApp(
//           home: Wrapper(),
//         ),
//       ),
//     );
//   }
// }