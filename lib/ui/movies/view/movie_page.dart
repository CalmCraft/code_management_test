import 'package:code_management_test/data/local_db/local_db.dart';
import 'package:code_management_test/data/model/movie/store_moive_object.dart';
import 'package:code_management_test/ui/movies/bloc/movie_bloc.dart';
import 'package:code_management_test/ui/movies/movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MovieType { upcoming, popular }

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  LocalDB db = LocalDB();
  @override
  void initState() {
    db.initializeDatabase();
    BlocProvider.of<MovieBloc>(context).add(GetMoviesEvent());
    super.initState();
  }

  List<StoreMovieObject> movies = [];

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
                      future: db.getUpcomingMovies(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<StoreMovieObject>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          movies.addAll(snapshot.data!);

                          return snapshot.data!.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Upcoming",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    SizedBox(
                                      height: 200,
                                      child: ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return MovieCard(
                                                imgPath: snapshot.data![index]
                                                    .movie!.posterPath
                                                    .toString());
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const SizedBox(
                                              width: 12,
                                            );
                                          },
                                          itemCount: snapshot.data!.length),
                                    )
                                  ],
                                );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                  FutureBuilder(
                      future: db.getPopularMovies(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<StoreMovieObject>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          movies.addAll(snapshot.data!);

                          return snapshot.data!.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Popular",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    SizedBox(
                                      height: 200,
                                      child: ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return MovieCard(
                                                imgPath: snapshot.data![index]
                                                    .movie!.posterPath
                                                    .toString());
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const SizedBox(
                                              width: 12,
                                            );
                                          },
                                          itemCount: snapshot.data!.length),
                                    )
                                  ],
                                );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ],
              );
            }
            if (state is MovieLoadedState) {
              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Upcoming",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return MovieCard(
                                  imgPath: state
                                      .upcomingMovies.results![index].posterPath
                                      .toString());
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                width: 12,
                              );
                            },
                            itemCount: state.upcomingMovies.results!.length),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Popular",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return MovieCard(
                                  imgPath: state
                                      .popularMovies.results![index].posterPath
                                      .toString());
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                width: 12,
                              );
                            },
                            itemCount: state.popularMovies.results!.length),
                      )
                    ],
                  )
                ],
              );
            }
            if (state is MovieErrorState) {
              return movies.isEmpty
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
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Upcoming",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView.separated(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return MovieCard(
                                      imgPath: movies[index]
                                          .movie!
                                          .posterPath
                                          .toString());
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    width: 12,
                                  );
                                },
                                itemCount: movies.length),
                          )
                        ],
                      ),
                    );

              /// Error State
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
