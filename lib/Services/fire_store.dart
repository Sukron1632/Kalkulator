import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  // Method to add a post to Firestore
  Future<void> addPost(String title, String content) {
    return posts.add({
      'title': title,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(), // Add server-side timestamp
    });
  }

  // Stream to get all posts in real-time
  Stream<List<Post>> getPosts() {
    return posts.orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Post.fromFirestore(doc);
        }).toList();
      },
    );
  }
}

// Post model for easier handling of data
class Post {
  final String title;
  final String content;
  final DateTime createdAt;

  Post({required this.title, required this.content, required this.createdAt});

  // Create Post instance from Firestore document
  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      title: data['title'],
      content: data['content'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
