import 'package:code_management_test/data/local_db/local_db.dart';
import 'package:code_management_test/data/model/movie/movie.dart';
import 'package:code_management_test/data/model/movie/store_moive_object.dart';
import 'package:code_management_test/ui/movies/bloc/movie_bloc.dart';
import 'package:code_management_test/ui/movies/movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MovieType { upcoming, popular }

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  List<Movie> upcomingMovies = [];
  List<Movie> popularMovies = [];

  @override
  void initState() {
    BlocProvider.of<MovieBloc>(context).add(GetMoviesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "What are you looking for?",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: BlocConsumer<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoadingState) {
              return Column(
                children: [
                  FutureBuilder(
                      future: SqfliteHelper.instance
                          .getMoviesByType(MovieType.upcoming),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<StoreMovieObject>> snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          for (var data in snapshot.data!) {
                            upcomingMovies.add(data.movie!);
                          }

                          return MovieListLayout(
                            movies: upcomingMovies,
                            label: "Upcoming",
                          );
                        }
                        return const MovieListLayoutShimmer();
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  FutureBuilder(
                      future: SqfliteHelper.instance
                          .getMoviesByType(MovieType.popular),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<StoreMovieObject>> snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          for (var data in snapshot.data!) {
                            popularMovies.add(data.movie!);
                          }
                          return MovieListLayout(
                            movies: popularMovies,
                            label: "Popular",
                          );
                        }
                        return const MovieListLayoutShimmer();
                      }),
                ],
              );
            }
            if (state is MovieLoadedState) {
              return Column(
                children: [
                  MovieListLayout(
                    movies: state.upcomingMovies.results!,
                    label: "Upcoming",
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  MovieListLayout(
                    movies: state.popularMovies.results!,
                    label: "Popular",
                  ),
                ],
              );
            }
            if (state is MovieErrorState) {
              return upcomingMovies.isEmpty && popularMovies.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("There was a problem\t:("),
                          ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<MovieBloc>(context)
                                    .add(GetMoviesEvent());
                              },
                              child: const Text("Retry"))
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MovieListLayout(
                          movies: upcomingMovies,
                          label: "Upcoming",
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        MovieListLayout(
                          movies: popularMovies,
                          label: "Popular",
                        ),
                      ],
                    );
            }
            return const SizedBox();
          },
          listener: (context, state) {
            if (state is MovieErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message.toString()),
              ));
            }
          },
        ),
      ),
    );
  }
}
