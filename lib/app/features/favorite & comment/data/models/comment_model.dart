class CommentModel {
  final int id;
  final String title;
  final String content;
  final int pageNumber;
  final String? createdAt;

  CommentModel({
    required this.id,
    required this.title,
    required this.content,
    required this.pageNumber,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content, 'page_number': pageNumber};
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      pageNumber: json['page_number'] ?? json['pageNumber'] ?? 0,
      createdAt: json['created_at'] ?? json['createdAt'],
    );
  }
}
