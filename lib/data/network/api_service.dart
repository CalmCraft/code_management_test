import 'package:code_management_test/data/model/movie/movie_list.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  static ApiService create() {
    Dio dio = Dio();

    dio.interceptors.add(PrettyDioLogger());
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    return ApiService(dio);
  }

  @GET('/movie/upcoming')
  Future<MovieList> getUpcomingMovies(@Query("api_key") String apiKey);

  @GET('/movie/popular')
  Future<MovieList> getPopularMovies(@Query("api_key") String apiKey);
}
