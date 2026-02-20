import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

class MovieViewModel extends ChangeNotifier {
  final MovieRepository _repository;
  
  Movie? _currentMovie;
  List<Movie> _favorites = [];
  bool _isLoading = false;
  String? _error;

  MovieViewModel({required MovieRepository repository})
      : _repository = repository;

  // Геттеры
  Movie? get currentMovie => _currentMovie;
  List<Movie> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Загрузить избранные фильмы
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _favorites = await _repository.getFavorites();
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Сгенерировать случайный фильм
  Future<void> generateRandomMovie() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentMovie = await _repository.getRandomMovie();
    } catch (e) {
      _error = 'Ошибка получения фильма: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Добавить в избранное
  Future<bool> addToFavorites(Movie movie) async {
    final success = await _repository.addToFavorites(movie);
    if (success) {
      await loadFavorites(); // Обновить список
    }
    return success;
  }

  // Удалить из избранного
  Future<bool> removeFromFavorites(String title) async {
    final success = await _repository.removeFromFavorites(title);
    if (success) {
      await loadFavorites(); // Обновить список
    }
    return success;
  }

  // Проверить, в избранном ли фильм
  Future<bool> isFavorite(String title) async {
    return await _repository.isFavorite(title);
  }
}