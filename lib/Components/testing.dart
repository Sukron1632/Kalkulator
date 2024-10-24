import 'package:AppaAja/Services/service_testing.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class TestingPage extends StatefulWidget {
  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

      await _firestoreService.addPost(
        _titleController.text,
        _linkController.text,
        false,
        imageUrl,
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

  // Function to open the "Add Website" dialog
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
                    borderRadius: BorderRadius.circular(7)
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white
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
                    foregroundColor: Colors.black
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _addPost,
                  style: ElevatedButton.styleFrom(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
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

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Function to toggle favorite status
  Future<void> _toggleFavorite(Post post) async {
    await _firestoreService.updatePost(post.id, !post.fav);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAddWebsiteDialog, // Open the popup when pressed
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Websites'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // First tab: Displaying all websites
          _buildAllWebsitesTab(),
          // Second tab: Displaying favorite websites
          _buildFavoriteWebsitesTab(),
        ],
      ),
    );
  }

  Widget _buildAllWebsitesTab() {
    return StreamBuilder<List<Post>>(
      stream: _firestoreService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching websites'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No websites found'));
        }

        // List of all posts
        final posts = snapshot.data!;
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return _buildPostCard(post);
          },
        );
      },
    );
  }

  Widget _buildFavoriteWebsitesTab() {
    return StreamBuilder<List<Post>>(
      stream: _firestoreService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching websites'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No favorite websites found'));
        }

        // List of favorite posts
        final posts = snapshot.data!.where((post) => post.fav).toList();
        if (posts.isEmpty) {
          return const Center(child: Text('No favorite websites found'));
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return _buildPostCard(post);
          },
        );
      },
    );
  }

  Widget _buildPostCard(Post post) {
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
          // _launchUrl(post.link);
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
                    post.link,
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
                  post.fav ? Icons.favorite : Icons.favorite_border,
                  color: post.fav ? Colors.red : null,
                ),
                onPressed: () {
                  _toggleFavorite(post);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
