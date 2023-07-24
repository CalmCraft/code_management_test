import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          CachedNetworkImage(imageUrl: "imageUrl"),
          Text("Title"),
          Row(
            children: [
              Icon(Icons.favorite_outline_rounded),
              Text("Preview Rate"),
              Text("Preview Rate"),
              Text("Preview Rate"),
            ],
          )
        ],
      ),
    );
  }
}
