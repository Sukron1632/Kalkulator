import 'package:AppaAja/Services/sites_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class WebsitePage extends StatefulWidget {
  @override
  _WebsitePageState createState() => _WebsitePageState();
}

class _WebsitePageState extends State<WebsitePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  File? _imageFile;
  String? userId;

  Map<String, bool> favoriteStatus = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $urlString');
    }
  }

  Future<void> _addPost() async {
    if (_titleController.text.isNotEmpty && _linkController.text.isNotEmpty) {
      String? imageUrl;

      if (_imageFile != null) {
        final loadingDialog = showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Adding..."),
                ],
              ),
            );
          },
        );

        imageUrl = await _uploadImage(_imageFile!);
        Navigator.of(context).pop();
      }

      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      String username = userEmail != null ? userEmail.split('@')[0] : 'unknown user';

      await _firestoreService.addPost(
        _titleController.text,
        _linkController.text,
        imageUrl,
        username,
      );

      _titleController.clear();
      _linkController.clear();
      setState(() {
        _imageFile = null;
      });
      Navigator.of(context).pop();
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('web_logos/$fileName');
      await ref.putFile(imageFile);
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _openAddWebsiteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Website'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Website Title'),
              ),
              TextField(
                controller: _linkController,
                decoration: const InputDecoration(labelText: 'Website Link'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Upload Image'),
              ),
              if (_imageFile != null) ...[
                const SizedBox(height: 8),
                Image.file(
                  _imageFile!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ],
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _addPost,
                  style: ElevatedButton.styleFrom(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Website'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchFavoriteStatus(String postId) async {
    try {
      bool isFavorited = await _firestoreService.isSiteFavorited(userId, postId);
      setState(() {
        favoriteStatus[postId] = isFavorited; // Store the status in the map
      });
    } catch (e) {
      // Handle the exception (e.g., log it or show a message)
      print("Error fetching favorite status: $e");
    }
  }


  Future<void> _toggleFavorite(Post post) async {
    bool isFavorited = await _firestoreService.isSiteFavorited(userId, post.id);
    
    if (isFavorited) {
      // If the site is already favorited, remove it
      await _firestoreService.updateUserFav(userId, post.id); // This will remove it
    } else {
      // If not, add it to favorites
      await _firestoreService.updateUserFav(userId, post.id);
    }

    // Refresh the favorite status after toggling
    _fetchFavoriteStatus(post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Recommended Sites'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.1,
        shadowColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: const Color.fromARGB(255, 134, 43, 15),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.language)),
            Tab(icon: Icon(Icons.favorite)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _tabAll(),
          _tabWebFavorit(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddWebsiteDialog,
        tooltip: 'Add Website',
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _tabAll() {
    return StreamBuilder<List<Post>>(
      stream: _firestoreService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching websites'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No websites found'));
        }

        final posts = snapshot.data!;
        
        // Fetch favorite status for each post
        for (var post in posts) {
          _fetchFavoriteStatus(post.id); // Fetch favorite status for each post
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return _websiteList(post);
          },
        );
      },
    );
  }


  Widget _tabWebFavorit() {
    return StreamBuilder<UserFav?>(
      stream: _firestoreService.getUserFav(userId!),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching user favorites'));
        }

        if (!snapshot.hasData || snapshot.data!.favoritSites.isEmpty) {
          return const Center(child: Text('No favorite websites found'));
        }

        final favoritSites = snapshot.data!.favoritSites;
        return StreamBuilder<List<Post>>(
          stream: _firestoreService.getFavoritePosts(favoritSites), // Ambil situs favorit berdasarkan favoritSites
          builder: (context, snapshot) {

            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching favorite websites'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No favorite websites found'));
            }

            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return _websiteList(post);
              },
            );
          },
        );
      },
    );
  }

  Widget _websiteList(Post post) {
    String uploader = post.uploader;

    // Default to false if the favorite status hasn't been fetched yet
    bool isFavorited = favoriteStatus[post.id] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 1,
        ),
        onPressed: () {
          _launchUrl(post.link);
        },
        child: SizedBox(
          width: double.infinity,
          height: 70,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  post.imageUrl ?? 'assets/images/appaaja.png',
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/appaaja.png',
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Uploaded by $uploader',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  _toggleFavorite(post); // Toggles the favorite status
                },
              ),
              // const Spacer(),
              // IconButton(
              //   icon: Icon(Icons.delete),
              //   onPressed: () async {
              //     await _firestoreService.deletePost(post.id);
              //     // Refresh UI or show a deletion confirmation
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
