class Photo {
  final String id;
  final String url;
  final String thumbnail;
  final int width;
  final int height;
  final String? category;
  final String? purity;
  final String? uploader;

  Photo({
    required this.id,
    required this.url,
    required this.thumbnail,
    required this.width,
    required this.height,
    this.category,
    this.purity,
    this.uploader,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] ?? '',
      url: json['path'] ?? '',
      thumbnail: json['thumbs']['large'] ?? json['path'] ?? '',
      width: json['resolution_x'] ?? 0,
      height: json['resolution_y'] ?? 0,
      category: json['category'],
      purity: json['purity'],
      uploader: json['uploader']?['username'],
    );
  }

  String get resolution => '${width} × ${height}';
  
  String get aspectRatio {
    if (width <= 0 || height <= 0) return 'N/A';
    
    int a = width;
    int b = height;
    
    while (b != 0) {
      final temp = b;
      b = a % b;
      a = temp;
    }
    
    final gcd = a;
    return '${width ~/ gcd}:${height ~/ gcd}';
  }
}