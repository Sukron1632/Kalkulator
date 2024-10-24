import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference websites = FirebaseFirestore.instance.collection('posts');

  Future<void> addPost(String title, String content, bool fav) {
    return websites.add({
      'title': title,
      'link': content,
      'fav': fav,
    });
  }

  Stream<List<Post>> getPosts() {
    return websites.orderBy('createdAt', descending: true).snapshots().map(
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
  final String link;
  final bool fav;

  Post({required this.title, required this.link, required this.fav});

  // Create Post instance from Firestore document
  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      title: data['title'],
      link: data['content'],
      fav: data[false],
    );
  }
}
