import 'package:AppaAja/Services/sites_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class websitePage extends StatefulWidget {
  @override
  _websitePageState createState() => _websitePageState();
}

class _websitePageState extends State<websitePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  File? _imageFile;

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $urlString');
    }
  }

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
            onPressed: _openAddWebsiteDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: const Color.fromARGB(255, 134, 43, 15),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(
              icon: Icon(Icons.language),
            ),
            Tab(
              icon: Icon(Icons.favorite),
            ),
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
    );
  }

  Widget _tabAll() {
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
  }

  Widget _tabWebFavorit() {
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

        final posts = snapshot.data!.where((post) => post.fav).toList();
        if (posts.isEmpty) {
          return const Center(child: Text('No favorite websites found'));
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

  Widget _websiteList(Post post) {
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
                  // const SizedBox(height: 5),
                  // Text(
                  //   post.link,
                  //   style: const TextStyle(
                  //     fontSize: 10,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  post.fav ? Icons.favorite : Icons.favorite_border,
                  color: post.fav ? Colors.red : Colors.black,
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
