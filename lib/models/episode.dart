class Episode {
  final String title;
  final String description;
  final String link;
  final String pubDate;
  final String audioUrl;

  Episode({
    required this.title,
    required this.description,
    required this.link,
    required this.pubDate,
    required this.audioUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      title: json['title']["__cdata"],
      description: json['description']["__cdata"],
      link: json['link']['\$t'],
      pubDate: json['pubDate']['\$t'],
      audioUrl: json['enclosure']['url'],
    );
  }
}
