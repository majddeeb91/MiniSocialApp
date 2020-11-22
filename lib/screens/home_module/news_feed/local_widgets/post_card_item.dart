import 'package:flutter/material.dart';
class PostCardItem extends StatelessWidget {
  const PostCardItem({
    Key key, this.username, this.avatarUrl, this.time, this.postText, this.postImageUrl, this.isLiked, this.numberOfLikes, this.onLikeTap,
  }) : super(key: key);
  final String username,avatarUrl,time,postText,postImageUrl;
  final bool isLiked;
  final int numberOfLikes;
  final Function onLikeTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 15,
            color: Colors.grey,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PostCardHeader(username: username,avatarUrl: avatarUrl,time: time,),
          PostCardText(text:postText,),
          postImageUrl == "" ? Container() : Image.network(
            postImageUrl,
            height: 170,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          PostCardActions(
            numberOfLikes: numberOfLikes,
            isLiked: isLiked,
            press: onLikeTap,
          )
        ],
      ),
    );
  }
}

class PostCardText extends StatelessWidget {
  const PostCardText({
    Key key, this.text,
  }) : super(key: key);
  final text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
              text:
              text,

              style: TextStyle(color: Colors.black))),
    );
  }
}

class PostCardActions extends StatelessWidget {
  const PostCardActions({
    Key key,
    this.numberOfLikes,
    this.isLiked,
    this.press,
  }) : super(key: key);
  final int numberOfLikes;
  final bool isLiked;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              icon: Icon(
                 isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.grey,
              ),
              onPressed: press),
          Spacer(),
          Text(numberOfLikes.toString()),
          SizedBox(width: 25),
        ],
      ),
    );
  }
}

class PostCardHeader extends StatelessWidget {
  const PostCardHeader({
    Key key, this.username, this.time, this.avatarUrl,
  }) : super(key: key);


  final String username,avatarUrl;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
          NetworkImage(avatarUrl),
        ),
        contentPadding: EdgeInsets.all(0),
        title: Text(
          username,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
