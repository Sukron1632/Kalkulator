import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart'; // for file basename

class UploadAndSaveToFirestore extends StatefulWidget {
  @override
  _UploadAndSaveToFirestoreState createState() => _UploadAndSaveToFirestoreState();
}

class _UploadAndSaveToFirestoreState extends State<UploadAndSaveToFirestore> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to upload image to Firebase Storage
  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = basename(imageFile.path);  // Get the file name
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('uploads/$fileName');  // Create a reference to Firebase Storage

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      print('Image uploaded successfully: $downloadURL');
      return downloadURL; // Return the download URL
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to save image URL to Firestore
  Future<void> _saveImageUrlToFirestore(String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('images').add({
        'url': imageUrl,
        'uploadedAt': Timestamp.now(),
      });
      print('Image URL saved to Firestore');
    } catch (e) {
      print('Error saving image URL to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image to Firebase and Save to Firestore'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Pick Image'),
          ),
          if (_image != null) Image.file(_image!, height: 200),
          ElevatedButton(
            onPressed: () async {
              if (_image != null) {
                // Step 1: Upload image to Firebase Storage
                String? downloadUrl = await _uploadImageToFirebase(_image!);
                if (downloadUrl != null) {
                  // Step 2: Save the download URL to Firestore
                  await _saveImageUrlToFirestore(downloadUrl);
                }
              }
            },
            child: Text('Upload to Firebase and Save URL'),
          ),
        ],
      ),
    );
  }
}
