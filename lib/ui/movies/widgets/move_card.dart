import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_management_test/ui/movie_detail/movie_detail.dart';
import 'package:flutter/material.dart';
import '../../../data/model/movie/movie.dart';
import '../../../domain/constants.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailPage(movie: movie)));
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: CachedNetworkImage(
          imageUrl: Constants.imgBaseUrl + movie.posterPath.toString(),
          height: 150,
        ),
      ),
    );
  }
}
