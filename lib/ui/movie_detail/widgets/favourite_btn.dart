import 'package:code_management_test/data/local_db/local_db.dart';
import 'package:code_management_test/data/model/movie_detail/favourite_movie.dart';
import 'package:flutter/material.dart';

class FavouriteBtn extends StatefulWidget {
  const FavouriteBtn({super.key, required this.movieId});
  final int movieId;
  @override
  State<FavouriteBtn> createState() => _FavouriteBtnState();
}

class _FavouriteBtnState extends State<FavouriteBtn> {
  bool isFavourite = false;

  void _toggleFavouriteFlag() {
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  void _updateFavouriteStatus(int isFavourite) {
    if (isFavourite == 1) {
      SqfliteHelper.instance.saveFavouriteMovie(
          FavouriteMovie(movieId: widget.movieId, isFavourite: 1));
    } else {
      SqfliteHelper.instance.unsaveFavouriteMovie(widget.movieId);
    }
  }

  void _getFavouriteFlag() {
    SqfliteHelper.instance
        .checkMovieFavourite(widget.movieId)
        .then((value) => setState(() => isFavourite = value));
  }

  @override
  void initState() {
    SqfliteHelper.instance
        .initializeDatabase()
        .whenComplete(() => _getFavouriteFlag());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _toggleFavouriteFlag();
          _updateFavouriteStatus(isFavourite == true ? 1 : 0);
        },
        child: isFavourite == true
            ? const Icon(
                Icons.favorite_rounded,
                color: Colors.red,
              )
            : const Icon(
                Icons.favorite_border_rounded,
              ));
  }
}
