import 'dart:math';
import '../models/movie.dart';

class MovieApiService {
  Future<Movie> getRandomMovie() async {
    // Имитация задержки сети для реалистичного UX
    await Future.delayed(const Duration(milliseconds: 800));

    final mockMovies = [
      {
        'Title': 'The Shawshank Redemption',
        'Year': '1994',
        'Genre': 'Drama',
        'Poster': 'https://m.media-amazon.com/images/M/MV5BMDFkYTc0MGEtZmNhMC00ZDIzLWFmNTEtODM1ZmRlYWMwMWFmXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg',
        'Plot': 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
        'imdbID': 'tt0111161',
        'Director': 'Frank Darabont',
        'Actors': 'Tim Robbins, Morgan Freeman',
        'imdbRating': '9.3',
      },
      {
        'Title': 'The Godfather',
        'Year': '1972',
        'Genre': 'Crime, Drama',
        'Poster': 'https://m.media-amazon.com/images/M/MV5BM2MyNjYxNmUtYTAwNi00MTYxLWJmNWYtYzZlODY3ZTk3OTFlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg',
        'Plot': 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
        'imdbID': 'tt0068646',
        'Director': 'Francis Ford Coppola',
        'Actors': 'Marlon Brando, Al Pacino',
        'imdbRating': '9.2',
      },
      {
        'Title': 'The Dark Knight',
        'Year': '2008',
        'Genre': 'Action, Crime, Drama',
        'Poster': 'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SX300.jpg',
        'Plot': 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests.',
        'imdbID': 'tt0468569',
        'Director': 'Christopher Nolan',
        'Actors': 'Christian Bale, Heath Ledger',
        'imdbRating': '9.0',
      },
      {
        'Title': 'Inception',
        'Year': '2010',
        'Genre': 'Action, Sci-Fi, Thriller',
        'Poster': 'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_SX300.jpg',
        'Plot': 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea.',
        'imdbID': 'tt1375666',
        'Director': 'Christopher Nolan',
        'Actors': 'Leonardo DiCaprio, Joseph Gordon-Levitt',
        'imdbRating': '8.8',
      },
      {
        'Title': 'Interstellar',
        'Year': '2014',
        'Genre': 'Adventure, Drama, Sci-Fi',
        'Poster': 'https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg',
        'Plot': 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
        'imdbID': 'tt0816692',
        'Director': 'Christopher Nolan',
        'Actors': 'Matthew McConaughey, Anne Hathaway',
        'imdbRating': '8.6',
      },
    ];

    final random = Random();
    final randomMovie = mockMovies[random.nextInt(mockMovies.length)];
    return Movie.fromJson(randomMovie);
  }

  Future<List<Movie>> searchMovies(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return await getRandomMovie().then((movie) => [movie]);
  }
}