part of 'movie_bloc.dart';

@immutable
abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoadingState extends MovieState {}

class MovieLoadedState extends MovieState {
  final MovieList upcomingMovies;
  final MovieList popularMovies;
  MovieLoadedState({required this.upcomingMovies, required this.popularMovies});
}

class MovieErrorState extends MovieState {}
