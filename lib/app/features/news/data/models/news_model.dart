// lib/app/features/news/data/models/news_model.dart
class NewsModel {
  final int id;
  final String title;
  final String content;
  final String img;
  final int dateTime;
  final String? photoUrl;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.img,
    required this.dateTime,
    this.photoUrl,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      img: json['img'] ?? '',
      dateTime: json['date_time'] ?? 0,
      photoUrl: json['photo_url'],
    );
  }

  String get imageUrl {
    return img;
  }

  DateTime get date {
    return DateTime.fromMillisecondsSinceEpoch(dateTime * 1000);
  }

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  String get shortContent {
    String cleaned = content.replaceAll(RegExp(r'<[^>]*>'), '');
    cleaned = cleaned.replaceAll('&nbsp;', ' ');
    if (cleaned.length > 100) {
      return cleaned.substring(0, 100) + '...';
    }
    return cleaned;
  }
}
