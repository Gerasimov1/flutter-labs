// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Список фильмов для генерации
  final List<Map<String, dynamic>> _movies = [
    {'title': 'Побег из Шоушенка', 'year': 1994, 'genre': 'Драма'},
    {'title': 'Крёстный отец', 'year': 1972, 'genre': 'Драма'},
    {'title': 'Тёмный рыцарь', 'year': 2008, 'genre': 'Боевик'},
    {'title': 'Начало', 'year': 2010, 'genre': 'Фантастика'},
    {'title': 'Интерстеллар', 'year': 2014, 'genre': 'Фантастика'},
    {'title': 'Матрица', 'year': 1999, 'genre': 'Фантастика'},
    {'title': 'Форрест Гамп', 'year': 1994, 'genre': 'Драма'},
    {'title': 'Бойцовский клуб', 'year': 1999, 'genre': 'Драма'},
  ];

  // Текущий случайный фильм
  Map<String, dynamic>? _currentMovie;

  // Избранные фильмы
  final List<Map<String, dynamic>> _favorites = [];

  // Генерация случайного фильма
  void _generateRandomMovie() {
    final random = _movies[DateTime.now().millisecond % _movies.length];
    setState(() {
      _currentMovie = random;
    });
  }

  // Добавление в избранное (без дубликатов)
  void _addToFavorites() {
    if (_currentMovie != null) {
      // Проверяем, есть ли уже этот фильм в избранном
      final isAlreadyFavorite = _favorites.any(
        (movie) => movie['title'] == _currentMovie!['title'],
      );

      if (isAlreadyFavorite) {
        // Показываем уведомление что фильм уже в избранном
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Этот фильм уже в избранном!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        // Добавляем фильм
        setState(() {
          _favorites.add(Map.from(_currentMovie!));
        });
        // Показываем уведомление об успехе
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Фильм "${_currentMovie!['title']}" добавлен в избранное!'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Генератор случайного фильма',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Карточка текущего фильма
            if (_currentMovie != null)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      _currentMovie!['title'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_currentMovie!['year']} • ${_currentMovie!['genre']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
            else
              const Text(
                'Нажмите кнопку, чтобы получить случайный фильм!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 20),

            // 🔴 Кнопка "Случайный фильм"
            ElevatedButton(
              onPressed: _generateRandomMovie,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(200, 80),
              ),
              child: const Text(
                '🎲 Случайный\nфильм',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Кнопка "Добавить в избранное"
            if (_currentMovie != null)
              ElevatedButton.icon(
                onPressed: _addToFavorites,
                icon: const Icon(Icons.favorite),
                label: const Text('Добавить в избранное'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Переход на экран избранного
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favorites: _favorites,
                    onRemoveFavorite: (index) {
                      setState(() {
                        _favorites.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Избранное (${_favorites.length})',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}