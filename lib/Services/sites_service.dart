import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference websites = FirebaseFirestore.instance.collection('websites');

  Future<void> addPost(String title, String link, bool fav) {
    return websites.add({
      'title': title,
      'link': link,
      'fav': fav,
    });
  }

  Stream<List<Post>> getPosts() {
    return websites.orderBy('title', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Post.fromFirestore(doc);
        }).toList();
      },
    );
  }

  Future<void> updatePost(String id, bool newFavStatus) {
    return websites.doc(id).update({
      'fav': newFavStatus,
    });
  }
}

class Post {
  final String id;
  final String title;
  final String link;
  final bool fav;

  Post({required this.id, required this.title, required this.link, required this.fav});

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'],
      link: data['link'],
      fav: data['fav'],
    );
  }
}
