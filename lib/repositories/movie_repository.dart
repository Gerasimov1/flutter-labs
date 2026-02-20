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

  // Получить случайный фильм (из API)
  Future<Movie> getRandomMovie() async {
    return await _apiService.getRandomMovie();
  }

  // Получить избранные фильмы (из БД)
  Future<List<Movie>> getFavorites() async {
    return await _dbHelper.getFavorites();
  }

  // Добавить в избранное (в БД)
  Future<bool> addToFavorites(Movie movie) async {
    // Проверка на дубликат
    if (await _dbHelper.isFavorite(movie.title)) {
      return false;
    }
    await _dbHelper.insertFavorite(movie);
    return true;
  }

  // Удалить из избранного (из БД)
  Future<bool> removeFromFavorites(String title) async {
    final result = await _dbHelper.deleteFavorite(title);
    return result > 0;
  }

  // Проверить, в избранном ли фильм
  Future<bool> isFavorite(String title) async {
    return await _dbHelper.isFavorite(title);
  }
}