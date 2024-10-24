import 'package:AppaAja/Services/fire_store.dart';
import 'package:flutter/material.dart';

class websitePage extends StatefulWidget {
  @override
  _websitePageState createState() => _websitePageState();
}

class _websitePageState extends State<websitePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  // Function to handle adding a post
  Future<void> _addPost() async {
    if (_titleController.text.isNotEmpty && _linkController.text.isNotEmpty) {
      await _firestoreService.addPost(
        _titleController.text,
        _linkController.text,
      );
      // Clear the input fields
      _titleController.clear();
      _linkController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Posts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form for adding posts
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Post Title'),
            ),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(labelText: 'Post Content'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addPost,
              child: Text('Add Post'),
            ),
            SizedBox(height: 16),
            // Displaying posts in real-time
            Expanded(
              child: StreamBuilder<List<Post>>(
                stream: _firestoreService.getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error fetching posts'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No posts found'));
                  }

                  // List of posts
                  final posts = snapshot.data!;
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        child: ListTile(
                          title: Text(post.title),
                          subtitle: Text(post.content),
                          trailing: Text(
                            post.createdAt.toLocal().toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
