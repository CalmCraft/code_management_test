import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:code_management_test/data/local_db/local_db.dart';
import 'package:code_management_test/data/model/movie/movie_list.dart';
import 'package:code_management_test/data/model/movie/store_moive_object.dart';
import 'package:code_management_test/data/network/api_service.dart';
import 'package:code_management_test/domain/constants.dart';
import 'package:code_management_test/ui/movies/view/movie_page.dart';
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
      await db.truncateTable();
      for (var movie in upcomingMovies.results!) {
        await db.storeMovies(StoreMovieObject(
          movieId: movie.id,
          movieInfo: jsonEncode(movie.toJson()),
          type: MovieType.upcoming.name,
        ));
      }
      for (var movie in popularMovies.results!) {
        await db.storeMovies(StoreMovieObject(
          movieId: movie.id,
          movieInfo: jsonEncode(movie.toJson()),
          type: MovieType.popular.name,
        ));
      }
      emit(MovieLoadedState(
          upcomingMovies: upcomingMovies, popularMovies: popularMovies));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        emit(MovieErrorState(message: "Error occurring in fetching data."));
      }
      if (e.type == DioExceptionType.connectionError) {
        emit(MovieErrorState(message: "Connection Error"));
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        emit(MovieErrorState(message: 'Connection Timeout'));
      }
    } on SocketException catch (e) {
      emit(MovieErrorState(message: e.message.toString()));
    }
  }
}
