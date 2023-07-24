import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../domain/constants.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.imgPath});
  final String imgPath;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: CachedNetworkImage(
        imageUrl: Constants.imgBaseUrl + imgPath.toString(),
        height: 150,
      ),
    );
  }
}
