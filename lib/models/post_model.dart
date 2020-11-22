import 'package:social_network_test/models/user_model.dart';
import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  PostModel({
    this.text,
    this.owner,
    this.creationDate,
    this.imageUrl,
    this.ownerId,
    this.postId,
    this.isLiked,
    this.likedBy,
  });

  String text;
  UserModel owner;
  DateTime creationDate;
  String imageUrl;
  String ownerId;
  String postId;
  bool isLiked;
  List<String> likedBy;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        text: json["text"],
        owner: UserModel.fromJson(json["owner"]),
        creationDate: json['creation_date'].toDate(),
        imageUrl: json["image_url"],
        ownerId: json["owner_id"],
        postId: json["post_id"],
        isLiked: json["is_liked"],
        likedBy: List<String>.from(json["liked_by"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "owner": owner.toJson(),
        "creation_date": creationDate,
        "image_url": imageUrl,
        "owner_id": ownerId,
        "post_id": postId,
        "is_liked": isLiked,
        "liked_by": List<dynamic>.from(likedBy.map((x) => x)),
      };
}
