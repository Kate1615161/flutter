import 'package:flutter/material.dart';
import 'package:lab6/models/photo.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends StatelessWidget {
  final Photo photo;

  const DetailScreen({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'image_${photo.id}',
              child: CachedNetworkImage(
                imageUrl: photo.url,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resolution: ${photo.resolution}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Aspect Ratio: ${photo.aspectRatio}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  if (photo.category != null)
                    Text(
                      'Category: ${photo.category}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 10),
                  if (photo.purity != null)
                    Text(
                      'Purity: ${photo.purity}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 10),
                  if (photo.uploader != null)
                    Text(
                      'Uploader: ${photo.uploader}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    'About Wallhaven:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Wallhaven - это динамичное сообщество любителей обоев, где пользователи "
                    "делятся красивыми обоями и открывают для себя новые. Это изображение "
                    "из коллекции Wallhaven",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}