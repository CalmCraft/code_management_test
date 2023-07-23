import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_management_test/ui/movies/bloc/movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/constants.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
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
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoadingState) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is MovieLoadedState) {
            return Column(
              children: [
                const Text("Upcoming"),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl: Constants.imgBaseUrl +
                                    state.upcomingMovies.results![index]
                                        .posterPath
                                        .toString(),
                                height: 150,
                              ),
                              const Text("")
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 12,
                        );
                      },
                      itemCount: state.upcomingMovies.results!.length),
                )
              ],
            );
          }
          if (state is MovieErrorState) {}
          return const SizedBox();
        },
      ),
    );
  }
}
