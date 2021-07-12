import 'package:youtube_api/constants.dart';

class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
  });

  factory Video.fromMap(Map<String, dynamic> snippet) {
    Map<String, dynamic> thumbnailsList = snippet['thumbnails'];

    bool keyNotFound = false;
    if (!thumbnailsList.containsKey('high')) {
      keyNotFound = true;
    }

    return Video(
      id: snippet['resourceId']['videoId'],
      title: snippet['title'],
      channelTitle: snippet['channelTitle'],
      thumbnailUrl: keyNotFound
          ? snippet['thumbnails'] = DEFAULT_IMAGE
          : snippet['thumbnails']['high']['url'],
    );
  }
}
