import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_management_test/data/model/movie/movie.dart';
import 'package:code_management_test/domain/constants.dart';
import 'package:code_management_test/ui/movie_detail/movie_detail.dart';
import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 25,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: Constants.imgBaseUrl + movie.posterPath.toString(),
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    movie.title.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FavouriteBtn(
                  movieId: movie.id!,
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Text("Release Date:"),
                    Text("\t${movie.releaseDate}"),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
