class ContentModel {
  final String uid;
  final String description;
  final String content;
  final int possibilities;
  final int accountUid;
  final List<String> contents;

  const ContentModel({
    required this.uid,
    required this.description,
    required this.content,
    required this.possibilities,
    required this.accountUid,
    this.contents = const [],
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      uid: (json['uid'] as int).toString(),
      description: json['description'] as String,
      content: json['content'] as String,
      possibilities: json['possibilities'] as int,
      accountUid: json['account_uid'] as int,
      contents: json['contents'] as List<String>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'description': description,
      'content': content,
      'possibilities': possibilities,
      'account_uid': accountUid,
      'contents': contents,
    };
  }
}
