class HackerNews {
  final String author;
  final String title;
  final String url;
  final int id;
  final String updatedAt;

  HackerNews({
    required this.id,
    required this.author,
    required this.url,
    required this.title,
    required this.updatedAt,
  });

  factory HackerNews.fromJson(Map<String, dynamic> json) => HackerNews(
      id: json['story_id'] ?? 0,
      author: json['author']??"",
      url: json['url']??"",
      title: json['title']??"",
      updatedAt: json['updated_at']??""
      );
}
