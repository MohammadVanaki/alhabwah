// lib/app/features/rawafid/data/models/rawafid_model.dart
class RawafidModel {
  final int id;
  final String title;
  final String content;
  final String link;

  RawafidModel({
    required this.id,
    required this.title,
    required this.content,
    required this.link,
  });

  factory RawafidModel.fromJson(Map<String, dynamic> json) {
    return RawafidModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      link: json['link'] ?? '',
    );
  }

  String get shortContent {
    if (content.length > 100) {
      return '${content.substring(0, 100)}...';
    }
    return content;
  }
}
