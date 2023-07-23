import 'package:code_management_test/ui/movies/bloc/movie_bloc.dart';
import 'package:code_management_test/ui/movies/view/movies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../data/network/api_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<ApiService>(
        create: (context) => ApiService.create(),
        child: Consumer<ApiService>(
          builder: (context, apiService, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<MovieBloc>(
                  create: (context) => MovieBloc(apiService: apiService),
                ),
              ],
              child: MaterialApp(
                title: "Code Management Test",
                home: const MoviePage(),
              ),
            );
          },
        ));
  }
}
