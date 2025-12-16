class UpdatedPageModel {
  final int id;
  final int bookId;
  final String page;
  final String content;

  UpdatedPageModel({
    required this.id,
    required this.bookId,
    required this.page,
    required this.content,
  });

  factory UpdatedPageModel.fromJson(Map<String, dynamic> json) {
    return UpdatedPageModel(
      id: json['id'] ?? 0,
      bookId: json['book_id'] ?? 0,
      page: json['page']?.toString() ?? '0',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'book_id': bookId, 'page': page, 'content': content};
  }
}
