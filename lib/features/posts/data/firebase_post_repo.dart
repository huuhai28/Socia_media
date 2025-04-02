import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_socia_media/features/posts/domain/entities/comment.dart';
import 'package:project_socia_media/features/posts/domain/entities/post.dart';
import 'package:project_socia_media/features/posts/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // store the posts in a collection called 'post'
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection("posts");

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      // get all posts most recent posts at the top
      final QuerySnapshot<Object?> postsSnapshot = await postsCollection
          .orderBy("timestamp",
              descending: true) // Sắp xếp theo thời gian (mới nhất trước)
          .limit(20)
          .get();

      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data()
              as Map<String, dynamic>)) // Chuyển từng document thành Post
          .toList();

      return allPosts;
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      // get all post with most recent post at the top
      final QuerySnapshot<Object?> postsSnapshot =
          await postsCollection.where("userId", isEqualTo: userId).get();
      final List<Post> userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userPosts;
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> toggleLikePost(
      String postId, String userId, bool setIslike) async {
    try {
      if (setIslike == true) {
        await postsCollection.doc(postId).update({
          'likes': FieldValue.arrayUnion([userId])
        });
      } else {
        await postsCollection.doc(postId).update({
          'likes': FieldValue.arrayRemove([userId])
        });
      }
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postsCollection.doc(postId).update({
        "comments": FieldValue.arrayUnion([comment.toJson()])
      });
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        // convert json object -> post
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // add the new comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        // update the post document in firestore
        await postsCollection.doc(postId).update({
          "comments": post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }
}
