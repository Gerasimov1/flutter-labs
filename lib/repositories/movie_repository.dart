import '../models/movie.dart';
import '../services/movie_api_service.dart';
import '../utils/database_helper.dart';

class MovieRepository {
  final MovieApiService _apiService;
  final DatabaseHelper _dbHelper;

  MovieRepository({
    required MovieApiService apiService,
    required DatabaseHelper dbHelper,
  })  : _apiService = apiService,
        _dbHelper = dbHelper;

  Future<Movie> getRandomMovie() async {
    return await _apiService.getRandomMovie();
  }

  Future<List<Movie>> getFavorites() async {
    return await _dbHelper.getFavorites();
  }

  Future<bool> addToFavorites(Movie movie) async {

    if (await _dbHelper.isFavorite(movie.title.trim())) {
      return false;
    }
    await _dbHelper.insertFavorite(movie);
    return true;
  }

  Future<bool> removeFromFavorites(String title) async {

    final result = await _dbHelper.deleteFavorite(title.trim());
    return result > 0;
  }

  Future<bool> isFavorite(String title) async {
    return await _dbHelper.isFavorite(title.trim());
  }
}