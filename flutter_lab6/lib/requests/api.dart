import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '/models/photo.dart';

class ApiService {
  static const String _baseUrl = 'https://wallhaven.cc/api/v1';
  final Random _random = Random();
  
  Future<List<Photo>> fetchPhotos({
    int page = 1,
    String category = '010',
    String purity = '100',
    String? search,
    String sorting = 'date_added',
    String order = 'desc',
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'categories': category,
        'purity': purity,
        'sorting': sorting,
        'order': order,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['q'] = search;
      }

      final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        
        return data.map((item) => Photo.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load photos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching photos: $e');
    }
  }

  Future<List<Photo>> fetchRandomPhotos() async {
    final categories = ['100', '010', '001', '110', '101', '011', '111'];
    final purities = ['100', '110', '111'];
    final sortings = ['random', 'date_added', 'toplist', 'views'];
    
    return fetchPhotos(
      page: _random.nextInt(5) + 1,
      category: categories[_random.nextInt(categories.length)],
      purity: purities[_random.nextInt(purities.length)],
      sorting: sortings[_random.nextInt(sortings.length)],
      order: _random.nextBool() ? 'desc' : 'asc',
    );
  }
}