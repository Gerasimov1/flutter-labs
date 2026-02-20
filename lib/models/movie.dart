class Movie {
  final String title;
  final String? year;
  final String? genre;
  final String? poster;
  final String? plot;
  final String? imdbId;
  final String? director;
  final String? actors;
  final String? rating;

  Movie({
    required this.title,
    this.year,
    this.genre,
    this.poster,
    this.plot,
    this.imdbId,
    this.director,
    this.actors,
    this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? 'Неизвестно',
      year: json['Year'],
      genre: json['Genre'],
      poster: json['Poster'] != 'N/A' 
          ? json['Poster']?.toString().trim() 
          : null,
      plot: json['Plot'],
      imdbId: json['imdbID'],
      director: json['Director'],
      actors: json['Actors'],
      rating: json['imdbRating'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title.trim(),
      'year': year,
      'genre': genre,
      'poster': poster,
      'plot': plot,
      'imdbId': imdbId,
      'director': director,
      'actors': actors,
      'rating': rating,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'] ?? 'Неизвестно',
      year: map['year'],
      genre: map['genre'],
      poster: map['poster'],
      plot: map['plot'],
      imdbId: map['imdbId'],
      director: map['director'],
      actors: map['actors'],
      rating: map['rating'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie && 
      runtimeType == other.runtimeType && 
      imdbId == other.imdbId;

  @override
  int get hashCode => imdbId?.hashCode ?? title.hashCode;
}