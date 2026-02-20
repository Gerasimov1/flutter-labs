import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

class MovieViewModel extends ChangeNotifier {
  final MovieRepository _repository;
  
  Movie? _currentMovie;
  List<Movie> _favorites = [];
  
  bool _isLoadingMovie = false;
  bool _isLoadingFavorites = false;
  String? _error;

  MovieViewModel({required MovieRepository repository})
      : _repository = repository;

  Movie? get currentMovie => _currentMovie;
  List<Movie> get favorites => _favorites;
  bool get isLoadingMovie => _isLoadingMovie;
  bool get isLoadingFavorites => _isLoadingFavorites;
  String? get error => _error;

  Future<void> loadFavorites() async {
    _isLoadingFavorites = true;
    _error = null;
    notifyListeners();
    
    try {
      _favorites = await _repository.getFavorites();
      _error = null;
      if (kDebugMode) {
        print('✅ Загружено избранное: ${_favorites.length} фильмов');
      }
    } catch (e) {
      _error = 'Ошибка загрузки избранного: $e';
      if (kDebugMode) print('❌ $e');
    } finally {
      _isLoadingFavorites = false;
      notifyListeners();
    }
  }

  Future<void> generateRandomMovie() async {
    _error = null;
    _isLoadingMovie = true;
    notifyListeners();
    
    try {
      _currentMovie = await _repository.getRandomMovie();
      _error = null;
      if (kDebugMode) {
        print('✅ Загружен фильм: ${_currentMovie?.title}');
      }
    } catch (e) {
      _error = 'Ошибка получения фильма: $e';
      if (kDebugMode) print('❌ $e');
    } finally {
      _isLoadingMovie = false;
      notifyListeners();
    }
  }

  Future<bool> addToFavorites(Movie movie) async {
    _error = null;
    notifyListeners();
    
    try {
      final success = await _repository.addToFavorites(movie);
      if (success) {
        await loadFavorites();
      }
      return success;
    } catch (e) {
      _error = 'Ошибка добавления: $e';
      if (kDebugMode) print('❌ $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFromFavorites(String title) async {
    _error = null;
    notifyListeners();
    
    try {
      final success = await _repository.removeFromFavorites(title);
      if (success) {
        await loadFavorites();
      }
      return success;
    } catch (e) {
      _error = 'Ошибка удаления: $e';
      if (kDebugMode) print('❌ $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> isFavorite(String title) async {
    try {
      return await _repository.isFavorite(title);
    } catch (_) {
      return false;
    }
  }
}