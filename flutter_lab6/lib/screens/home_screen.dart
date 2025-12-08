import 'package:flutter/material.dart';
import 'package:lab6/requests/api.dart';
import 'package:lab6/models/photo.dart';
import 'package:lab6/screens/detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Photo> _photos = [];
  bool _isLoading = true;
  bool _hasMore = true;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPhotos();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPhotos({bool loadMore = false}) async {
    if (!loadMore) {
      setState(() {
        _isLoading = true;
        _currentPage = 1;
      });
    }

    try {
      final newPhotos = await _apiService.fetchPhotos(
        page: _currentPage,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      setState(() {
        if (loadMore) {
          _photos.addAll(newPhotos);
        } else {
          _photos = newPhotos;
        }
        _hasMore = newPhotos.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> _refreshPhotos() async {
    setState(() {
      _currentPage = 1;
      _searchQuery = '';
      _searchController.clear();
    });
    await _loadPhotos();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_hasMore && !_isLoading) {
        setState(() {
          _currentPage++;
        });
        _loadPhotos(loadMore: true);
      }
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    _loadPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallhaven - Лопаткина Екатерина ИСТУ-22-2'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPhotos,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search wallpapers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: _isLoading && _photos.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _photos.isEmpty
                    ? const Center(
                        child: Text('No images found'),
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                        padding: const EdgeInsets.all(8),
                        itemCount: _photos.length + (_hasMore ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index >= _photos.length) {
                            return _isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : Container();
                          }

                          final photo = _photos[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(photo: photo),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: photo.thumbnail,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}