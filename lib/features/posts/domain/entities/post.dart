// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_socia_media/features/posts/domain/entities/comment.dart';

class Post {
  final String id;
  final String text;
  final String userName;
  final String userId;
  final DateTime timestamp;
  final String imageUrl;
  final List<String> likes;
  final List<Comment> comments;
  Post({
    required this.id,
    required this.text,
    required this.userName,
    required this.userId,
    required this.timestamp,
    required this.imageUrl,
    required this.likes,
    required this.comments,
  });

  Post copyWith({String? imageUrl}) {
    return Post(
        id: id,
        userId: userId,
        userName: userName,
        text: text,
        imageUrl: imageUrl ?? this.imageUrl,
        timestamp: timestamp,
        likes: likes,
        comments: comments);
  }

  // convert post -> json
  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "userName": userName,
        "userId": userId,
        "imageUrl": imageUrl,
        "timestamp": Timestamp.fromDate(timestamp),
        "likes": likes,
        "comments": comments.map((e) => e.toJson()).toList(),
      };

  // convert json -> post

  factory Post.fromJson(Map<String, dynamic> json) {
    // prepare comment
    final List<Comment> comments = (json['comments'] as List<dynamic>?)
            ?.map((commentJson) => Comment.fromJson(commentJson))
            .toList() ??
        [];
    return Post(
      id: json["id"],
      text: json["text"],
      userName: json["userName"],
      userId: json["userId"],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      imageUrl: json["imageUrl"],
      likes: List.from(json['like'] ?? []),
      comments: comments,
    );
  }
}
