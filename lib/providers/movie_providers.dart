import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieProvider extends ChangeNotifier {
  List<Map<String, dynamic>> movies = [];
  bool isLoading = false;

  Future<void> fetchMovies(String query) async {
    if (query.isEmpty) {
      movies = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://www.omdbapi.com/?s=$query&apikey=70ee5f2a');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data'); 
        if (data['Search'] != null) {
          movies = (data['Search'] as List).map((movie) {
            return {
              'title': movie['Title'] ?? 'N/A',
              'poster': movie['Poster'] ?? '',
              'year': movie['Year'] ?? 'Unknown Year',
              'type': movie['Type'] ?? 'Unknown Type',
              'genre': 'N/A', 
              'rating': 'N/A', 
            };
          }).toList();

          for (var movie in movies) {
            final detailsUrl = Uri.parse('https://www.omdbapi.com/?t=${movie['title']}&apikey=70ee5f2a');
            final detailsResponse = await http.get(detailsUrl);

            if (detailsResponse.statusCode == 200) {
              final detailsData = json.decode(detailsResponse.body);
              if (detailsData['Genre'] != null) {
                movie['genre'] = detailsData['Genre'] ?? 'N/A';
              }
              if (detailsData['imdbRating'] != null) {
                movie['rating'] = detailsData['imdbRating'] ?? 'N/A';
              }
            }
          }
        } else {
          movies = [];
        }
      } else {
        movies = [];
      }
    } catch (e) {
      print('Error fetching movies: $e');
      movies = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
