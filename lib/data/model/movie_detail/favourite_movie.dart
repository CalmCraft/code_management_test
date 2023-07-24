class FavouriteMovie {
  int? movieId;
  int? isFavourite;

  FavouriteMovie({this.movieId, this.isFavourite});

  FavouriteMovie.fromJson(Map<String, dynamic> json) {
    movieId = json['movie_id'];
    isFavourite = json['is_favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['movie_id'] = movieId;
    data['is_favourite'] = isFavourite;
    return data;
  }
}
