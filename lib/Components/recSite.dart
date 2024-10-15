import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecSite extends StatefulWidget {
  const RecSite({super.key});

  @override
  _RecsiteState createState() => _RecsiteState();
}

class _RecsiteState extends State<RecSite> {
  final List<Map<String, dynamic>> _sites = [
    {
      "name": "Spada Wimaya UPNYK",
      "url": "https://spada.upnyk.ac.id",
      "image": 'assets/images/upn.png',
      "isFavorite": false,
    },
    {
      "name": "Stack Overflow",
      "url": "https://stackoverflow.com",
      "image": 'assets/images/stackoverflow.png',
      "isFavorite": false,
    },
    {
      "name": "ChatGPT",
      "url": "https://chatgpt.com",
      "image": 'assets/images/GPT.png',
      "isFavorite": false,
    },
  ];

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $urlString');
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      _sites[index]['isFavorite'] = !_sites[index]['isFavorite'];
    });
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
      ),
      body: ListView.builder(
        itemCount: _sites.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              onPressed: () => _launchUrl(_sites[index]['url']),
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(_sites[index]['image']),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _sites[index]['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _sites[index]['url'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        _sites[index]['isFavorite']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _sites[index]['isFavorite'] ? Colors.red : null,
                      ),
                      onPressed: () {
                        _toggleFavorite(index);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
