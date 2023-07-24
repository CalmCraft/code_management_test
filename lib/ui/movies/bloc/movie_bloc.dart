import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:code_management_test/data/local_db/local_db.dart';
import 'package:code_management_test/data/model/movie.dart';
import 'package:code_management_test/data/model/movie_list.dart';
import 'package:code_management_test/data/model/store_moives_object.dart';
import 'package:code_management_test/data/network/api_service.dart';
import 'package:code_management_test/domain/constants.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final ApiService apiService;
  MovieBloc({required this.apiService}) : super(MovieInitial()) {
    on<GetMoviesEvent>(_getMovies);
  }
  void _getMovies(GetMoviesEvent event, Emitter emit) async {
    emit(MovieLoadingState());
    LocalDB db = LocalDB();
    await db.initializeDatabase();
    try {
      final upcomingMovies =
          await apiService.getUpcomingMovies(Constants.apiKey);
      final popularMovies = await apiService.getPopularMovies(Constants.apiKey);
      for (var movie in upcomingMovies.results!) {
        await db.storeMovies(StoreMovieObject(
          movieId: movie.id,
          movieInfo: jsonEncode(movie.toString()),
          type: "Upcoming",
        ));
      }
      emit(MovieLoadedState(
          upcomingMovies: upcomingMovies, popularMovies: popularMovies));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        emit(MovieErrorState());
      }
      if (e.type == DioExceptionType.connectionError) {
        emit(MovieErrorState());
      }
      if (e.type == DioExceptionType.unknown) {
        emit(MovieErrorState());
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        emit(MovieErrorState());
      } else {
        print(e.message.toString());
      }
    }
  }
}
