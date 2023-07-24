import 'package:code_management_test/data/model/movie/movie.dart';
import 'package:code_management_test/ui/movies/movies.dart';
import 'package:flutter/material.dart';

class MovieListLayout extends StatelessWidget {
  const MovieListLayout({super.key, required this.movies, required this.label});
  final List<Movie> movies;
  final String label;
  @override
  Widget build(BuildContext context) {
    return movies.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                      padding: const EdgeInsets.only(right: 12),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return MovieCard(
                          movie: movies[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 12,
                        );
                      },
                      itemCount: movies.length),
                )
              ],
            ),
          )
        : SizedBox();
  }
}
