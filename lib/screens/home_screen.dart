import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/movie_viewmodel.dart';
import '../models/movie.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MovieViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 Генератор фильмов'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Индикатор загрузки или ошибка
          if (viewModel.isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (viewModel.error != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Ошибка: ${viewModel.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          // Карточка текущего фильма
          else if (viewModel.currentMovie != null)
            _buildMovieCard(viewModel.currentMovie!)
          else
            const Expanded(
              child: Center(
                child: Text(
                  'Нажмите кнопку, чтобы получить случайный фильм!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Кнопка "Добавить в избранное"
          if (viewModel.currentMovie != null && !viewModel.isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FutureBuilder<bool>(
                future: viewModel.isFavorite(viewModel.currentMovie!.title),
                builder: (context, snapshot) {
                  final isFavorite = snapshot.data ?? false;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isFavorite
                          ? null
                          : () => _addToFavorites(context, viewModel),
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                      label: Text(isFavorite ? 'В избранном' : 'Добавить в избранное'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFavorite ? Colors.grey : Colors.pink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  );
                },
              ),
            ),


          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () => viewModel.generateRandomMovie(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  '🎲 СЛУЧАЙНЫЙ ФИЛЬМ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              viewModel.loadFavorites();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
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
            child: Consumer<MovieViewModel>(
              builder: (context, vm, _) => Text(
                'Избранное (${vm.favorites.length})',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Постер (с сохранением пропорций)
              if (movie.poster != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 300,
                    child: Image.network(
                      movie.poster!,
                      fit: BoxFit.contain, 
                      errorBuilder: (_, __, ___) => Container(
                        height: 300,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.movie,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 300,
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.movie,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(height: 16),

              // Название
              Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Год и жанр
              Text(
                '${movie.year ?? 'Неизвестно'} • ${movie.genre ?? 'Неизвестно'}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),

              // Рейтинг (если есть)
              if (movie.rating != null && movie.rating != 'N/A') ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '⭐ ${movie.rating}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],

              // Режиссёр (если есть)
              if (movie.director != null) ...[
                const SizedBox(height: 8),
                Text(
                  '🎬 ${movie.director}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ],

              // Описание (ограничено 3 строками)
              if (movie.plot != null) ...[
                const SizedBox(height: 12),
                const Text(
                  'Сюжет:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  movie.plot!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _addToFavorites(BuildContext context, MovieViewModel viewModel) {
    if (viewModel.currentMovie != null) {
      viewModel.addToFavorites(viewModel.currentMovie!).then((success) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Фильм добавлен в избранное!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚠️ Фильм уже в избранном!'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    }
  }
}