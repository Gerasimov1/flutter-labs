import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/movie_viewmodel.dart';
import 'repositories/movie_repository.dart';
import 'services/movie_api_service.dart';
import 'utils/database_helper.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final apiService = MovieApiService();
  final dbHelper = DatabaseHelper.instance;
  final repository = MovieRepository(
    apiService: apiService,
    dbHelper: dbHelper,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => MovieViewModel(repository: repository),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Picker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}