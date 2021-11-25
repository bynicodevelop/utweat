class ContentModel {
  final String name;
  final String content;
  final int possibilities;
  final List<String> tweets;

  const ContentModel({
    required this.name,
    required this.content,
    required this.possibilities,
    this.tweets = const [],
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      name: json['name'] as String,
      content: json['content'] as String,
      possibilities: json['possibilities'] as int,
      tweets: json['tweets'] as List<String>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'content': content,
      'possibilities': possibilities,
      'tweets': tweets,
    };
  }
}
