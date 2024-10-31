import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final CollectionReference websites = FirebaseFirestore.instance.collection('websites');

  // Menambahkan pengguna dengan userId dan array kosong untuk favoritSites
  Future<void> addUser(String userId) {
    return users.add({
      'userId': userId,
      'favoritSites': [], // Inisialisasi dengan array kosong
    });
  }

  // Mengambil pengguna dengan userId yang sudah login
  Stream<User?> getUserFav(String userId) {
    return users.where('userId', isEqualTo: userId).snapshots().map(
      (snapshot) {
        // Ambil dokumen pertama yang ditemukan (hanya satu pengguna yang diharapkan)
        if (snapshot.docs.isNotEmpty) {
          return User.fromFirestore(snapshot.docs.first);
        } else {
          return null; // Kembalikan null jika pengguna tidak ditemukan
        }
      },
    );
  }

  // Memperbarui favoritSites pengguna dengan menambahkan nama dokumen situs favorit baru
  Future<void> updateUserFav(String userId, String newSiteId) async {
    DocumentSnapshot userDoc = await users.where('userId', isEqualTo: userId).limit(1).get().then((snapshot) => snapshot.docs.first);
    
    if (userDoc.exists) {
      List<dynamic> favoritSites = userDoc['favoritSites'] ?? [];
      if (!favoritSites.contains(newSiteId)) { // Cek jika situs sudah ada di favorit
        favoritSites.add(newSiteId); // Menambahkan nama dokumen baru
      }
      return users.doc(userDoc.id).update({
        'favoritSites': favoritSites,
      });
    } else {
      throw Exception("Pengguna tidak ditemukan");
    }
  }
}

class User {
  final String id;
  final String userId;
  final List<String> favoritSites;

  User({required this.id, required this.userId, required this.favoritSites});

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      userId: data['userId'],
      favoritSites: List<String>.from(data['favoritSites'] ?? []), // Memastikan ini adalah List<String>
    );
  }
}
