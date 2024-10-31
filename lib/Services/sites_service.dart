import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference websites = FirebaseFirestore.instance.collection('websites');
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String userId) {
    return users.add({
      'userId': userId,
      'favoritSites': [],
    });
  }

  Stream<UserFav?> getUserFav(String userId) {
    return users.where('userId', isEqualTo: userId).snapshots().map(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return UserFav.fromFirestore(snapshot.docs.first);
        } else {
          return null;
        }
      },
    );
  }

  Future<void> updateUserFav(String? userId, String newSiteId) async {
    DocumentSnapshot userDoc = await users
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.isNotEmpty ? snapshot.docs.first : throw Exception("User not found"));

    if (userDoc.exists) {
      List<dynamic> favoritSites = userDoc['favoritSites'] ?? [];

      if (favoritSites.contains(newSiteId)) {
        favoritSites.remove(newSiteId);
      } else {
        favoritSites.add(newSiteId);
      }

      await users.doc(userDoc.id).update({
        'favoritSites': favoritSites,
      });
    } else {
      throw Exception("Pengguna tidak ditemukan");
    }
  }

  Future<bool> isSiteFavorited(String? userId, String postId) async {
    QuerySnapshot snapshot = await users.where('userId', isEqualTo: userId).limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = snapshot.docs.first;

      List<dynamic> favoritSites = userDoc['favoritSites'] ?? [];
      return favoritSites.contains(postId);
    } else {
      throw Exception("User not found");
    }
  }

  Future<void> addPost(String title, String link, String? imageUrl, String? username) {
    return websites.add({
      'title': title,
      'link': link,
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

  Stream<List<Post>> getFavoritePosts(List<String> favoritSites) {
    return websites.where(FieldPath.documentId, whereIn: favoritSites).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Post.fromFirestore(doc);
        }).toList();
      },
    );
  }

  Future<void> deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();

      final userDocsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('favoritSites', arrayContains: postId)
          .get();

      for (var userDoc in userDocsSnapshot.docs) {
        List<dynamic> favoritSites = userDoc['favoritSites'] ?? [];
        
        favoritSites.remove(postId);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .update({'favoritSites': favoritSites});
      }
    } catch (e) {
      print("Error deleting post and updating favorites: $e");
      throw Exception("Failed to delete post and update user favorites");
    }
  }
}



class UserFav {
  final String id;
  final String userId;
  final List<String> favoritSites;

  UserFav({required this.id, required this.userId, required this.favoritSites});

  factory UserFav.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserFav(
      id: doc.id,
      userId: data['userId'],
      favoritSites: List<String>.from(data['favoritSites'] ?? []),
    );
  }
}

class Post {
  final String id, title, link, uploader;
  final String? imageUrl;
  final Timestamp timestamp;

  Post({required this.id, required this.title, required this.link, this.imageUrl, required this.timestamp, required this.uploader});

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'],
      link: data['link'],
      imageUrl: data['imageUrl'],
      timestamp: data['timestamp'],
      uploader: data['uploader'],
    );
  }
}