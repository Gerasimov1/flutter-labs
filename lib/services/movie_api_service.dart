import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieApiService {
  static const String _apiKey = '67f0325f';
  static const String _baseUrl = 'https://www.omdbapi.com';

  // Получение случайного фильма (из тысяч!)
  Future<Movie> getRandomMovie() async {
    try {
      // Список популярных запросов для поиска
      final List<String> searchTerms = [
        'action', 'comedy', 'drama', 'horror', 'sci-fi',
        'thriller', 'romance', 'adventure', 'fantasy', 'crime',
        'animation', 'mystery', 'war', 'western', 'musical',
        '2023', '2022', '2021', '2020', '2019',
        'marvel', 'dc', 'disney', 'pixar', 'studio ghibli',
      ];

      // Выбираем случайный поисковый запрос
      final random = Random();
      final searchTerm = searchTerms[random.nextInt(searchTerms.length)];

      // Ищем фильмы по запросу
      final searchResponse = await http.get(
        Uri.parse('$_baseUrl/?apikey=$_apiKey&s=$searchTerm&type=movie'),
      ).timeout(const Duration(seconds: 10));

      if (searchResponse.statusCode == 200) {
        final searchData = json.decode(searchResponse.body);
        
        if (searchData['Response'] == 'True' && searchData['Search'] != null) {
          final List<dynamic> results = searchData['Search'];
          
          // Выбираем случайный фильм из результатов поиска
          final randomMovie = results[random.nextInt(results.length)];
          final imdbId = randomMovie['imdbID'];

          // Получаем полную информацию о фильме
          final movieResponse = await http.get(
            Uri.parse('$_baseUrl/?apikey=$_apiKey&i=$imdbId&plot=full'),
          ).timeout(const Duration(seconds: 10));

          if (movieResponse.statusCode == 200) {
            final movieData = json.decode(movieResponse.body);
            if (movieData['Response'] == 'True') {
              return Movie.fromJson(movieData);
            }
          }
        }
      }

      throw Exception('Не удалось получить случайный фильм');
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Поиск фильмов по названию
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/?apikey=$_apiKey&s=$query&type=movie'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['Response'] == 'True' && data['Search'] != null) {
          final List<dynamic> results = data['Search'];
          return results.map((json) => Movie.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Ошибка API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка поиска: $e');
    }
  }
}