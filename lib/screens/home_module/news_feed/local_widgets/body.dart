import 'package:flutter/material.dart';
import 'package:social_network_test/constants.dart';
import 'package:social_network_test/models/post_model.dart';
import 'package:social_network_test/screens/home_module/news_feed/local_widgets/post_card_item.dart';
import 'package:social_network_test/screens/home_module/news_feed/news_feed_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<NewsFeedViewModel>(builder: (context, viewmodel, child) {
      if (viewmodel.isLoading) {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: kPrimaryLightColor,
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
        );
      } else {
        if (viewmodel.posts == null) {
          return Center(child: Text("error"));
        } else {
          return Container(
            height: size.height,
            width: double.infinity,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: viewmodel.posts.length,
              itemBuilder: (context, index) {
                String creationDate =
                    getTimeAgoFormat(viewmodel.posts[index].creationDate);
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: PostCardItem(
                    username: viewmodel.posts[index].owner.fullName(),
                    avatarUrl: viewmodel.posts[index].owner.profilePictureURL,
                    time: creationDate,
                    postText: viewmodel.posts[index].text ?? "",
                    postImageUrl: viewmodel.posts[index].imageUrl,
                    numberOfLikes: viewmodel.posts[index].likedBy.length,
                    isLiked: viewmodel.posts[index].isLiked,
                    onLikeTap: () {
                      String currentPostId = viewmodel.posts[index].postId;
                      viewmodel.likePost(currentPostId);
                      // setState(() {
                      //   isLiked = !isLiked;
                      //   //isLiked ? numOflikes++ : numOflikes--;
                      // });
                      print("'taped");
                    },
                  ),
                );
              },
            ),
          );
        }
      }
    });
  }

  String getTimeAgoFormat(DateTime date) {
    return timeago.format(date, allowFromNow: true);
  }
}
