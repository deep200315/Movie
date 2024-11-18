import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/movie_providers.dart';
import 'widgets/movie_card.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MovieSearchScreen(),
    );
  }
}

class MovieSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              onChanged: (query) {
                movieProvider.fetchMovies(query);
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Movie ListView
            Expanded(
              child: movieProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : movieProvider.movies.isEmpty
                      ? Center(child: Text('Get started by searching for a movie!'))
                      : ListView.builder(
                          itemCount: movieProvider.movies.length,
                          itemBuilder: (context, index) {
                            final movie = movieProvider.movies[index];
                            return MovieCard(movie: movie.map((key, value) => MapEntry(key, value.toString())));
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}