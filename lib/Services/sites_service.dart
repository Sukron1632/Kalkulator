import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference websites = FirebaseFirestore.instance.collection('websites');

  Future<void> addPost(String title, String link, bool fav, String? imageUrl, String? username) {
    return websites.add({
      'title': title,
      'link': link,
      'fav': fav,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'uploader': username,
    });
  }

  Stream<List<Post>> getPosts() {
    return websites.orderBy('timestamp', descending: true).snapshots().map(
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
  final String id,title,link,uploader;
  final String? imageUrl;
  final bool fav;
  final Timestamp timestamp;

  Post({required this.id, required this.title, required this.link, required this.fav, this.imageUrl, required this.timestamp, required this.uploader});

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'],
      link: data['link'],
      fav: data['fav'],
      imageUrl: data['imageUrl'],
      timestamp: data['timestamp'],
      uploader: data['uploader']
    );
  }
}