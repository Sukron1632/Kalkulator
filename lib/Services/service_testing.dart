import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference websites = FirebaseFirestore.instance.collection('websites');
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Menambahkan pengguna dengan userId dan array kosong untuk favoritSites
  Future<void> addUser(String userId) {
    return users.add({
      'userId': userId,
      'favoritSites': [], // Inisialisasi dengan array kosong
    });
  }

  // Mengambil pengguna dengan userId yang sudah login
  Stream<UserFav?> getUserFav(String userId) {
    return users.where('userId', isEqualTo: userId).snapshots().map(
      (snapshot) {
        // Ambil dokumen pertama yang ditemukan (hanya satu pengguna yang diharapkan)
        if (snapshot.docs.isNotEmpty) {
          return UserFav.fromFirestore(snapshot.docs.first);
        } else {
          return null; // Kembalikan null jika pengguna tidak ditemukan
        }
      },
    );
  }

  Future<void> updateUserFav(String? userId, String newSiteId) async {
    // Fetch the user document based on userId
    DocumentSnapshot userDoc = await users
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.isNotEmpty ? snapshot.docs.first : throw Exception("User not found"));

    if (userDoc.exists) {
      List<dynamic> favoritSites = userDoc['favoritSites'] ?? [];

      // Check if the new site is already in favorites
      if (favoritSites.contains(newSiteId)) {
        // If it is, remove it from favorites
        favoritSites.remove(newSiteId);
      } else {
        // If it isn't, add it to favorites
        favoritSites.add(newSiteId);
      }

      // Update the user document with the modified favorites list
      await users.doc(userDoc.id).update({
        'favoritSites': favoritSites,
      });
    } else {
      throw Exception("Pengguna tidak ditemukan");
    }
  }

  Future<bool> isSiteFavorited(String? userId, String postId) async {
    // Query the user document where 'userId' matches the given userId
    QuerySnapshot snapshot = await users.where('userId', isEqualTo: userId).limit(1).get();

    // Check if there are any documents returned in the query
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = snapshot.docs.first; // Use .first to get the DocumentSnapshot

      List<dynamic> favoritSites = userDoc['favoritSites'] ?? [];
      return favoritSites.contains(postId); // Check if postId is in favoritSites array
    } else {
      throw Exception("User not found");
    }
  }

  // Menambahkan situs baru
  Future<void> addPost(String title, String link, String? imageUrl, String? username) {
    return websites.add({
      'title': title,
      'link': link,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'uploader': username,
    });
  }

  // Mengambil semua situs yang ada
  Stream<List<Post>> getPosts() {
    return websites.orderBy('timestamp', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Post.fromFirestore(doc);
        }).toList();
      },
    );
  }

  // Mendapatkan situs favorit berdasarkan daftar favorit pengguna
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
      // Delete the post document from the 'posts' collection in Firestore
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();

      // Get all users who have the postId in their favoritSites array
      final userDocsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('favoritSites', arrayContains: postId)
          .get();

      // Loop through each user document and remove the postId from favoritSites array
      for (var userDoc in userDocsSnapshot.docs) {
        List<dynamic> favoritSites = userDoc['favoritSites'] ?? [];
        
        // Remove the postId from favoritSites
        favoritSites.remove(postId);

        // Update the user's document with the modified favoritSites array
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
      favoritSites: List<String>.from(data['favoritSites'] ?? []), // Memastikan ini adalah List<String>
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
