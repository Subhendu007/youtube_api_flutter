import 'dart:convert';

import 'package:youtube_api/keys.dart';
import 'package:youtube_api/models/channel_model.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api/models/playlist_model.dart';
import 'package:youtube_api/models/videos.dart';

class ResponceHandeller {
  String _nextPageToken = '';

  Future<List<Video>> getVideosInfo({required String playlistId}) async {
    final queryParameters = {
      'part': 'snippet, contentDetails',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': Keys.API_KEY,
    };
    Uri uri = Uri.https(
        'youtube.googleapis.com', '/youtube/v3/playlistItems', queryParameters);
    print(uri);
    //getiitng playlist videos
    var responce = await http.get(uri);
    if (responce.statusCode == 200) {
      var json = jsonDecode(responce.body);

      _nextPageToken = json['nextPageToken'] ?? '';
      List<dynamic> videosJson = json['items'];

      //fetching first page videos
      List<Video> videos = [];
      videosJson.forEach(
        (element) => videos.add(
          Video.fromMap(element['snippet']),
        ),
      );
      return videos;
    } else {
      throw jsonDecode(responce.body)['error']['message'];
    }
  }

  Future<ChannelInfo> getChannelInfo({required String playlistId}) async {
    final queryParameters = {
      'part': 'contentDetails, snippet, statistics',
      'id': Keys.CHANNEL_ID,
      'key': Keys.API_KEY,
    };
    Uri uri = Uri.https(
        'youtube.googleapis.com', '/youtube/v3/channels', queryParameters);
    final responce = await http.get(uri);
    if (responce.statusCode == 200) {
      final json = jsonDecode(responce.body);
      ChannelInfo channelInfo = ChannelInfo.fromJson(json);

      channelInfo.videos = await getVideosInfo(playlistId: playlistId);
      return channelInfo;
    } else {
      throw jsonDecode(responce.body)['error']['message'];
    }
  }

  Future<PlaylistInfo> getPlaylistInfo() async {
    final queryParameters = {
      'part': 'id, snippet, contentDetails',
      'maxResults':'50',
      'channelId': Keys.CHANNEL_ID,
      'key': Keys.API_KEY,
    };
    Uri uri = Uri.https(
        'youtube.googleapis.com', '/youtube/v3/playlists', queryParameters);
    final responce = await http.get(uri);
    final json = jsonDecode(responce.body);
    return PlaylistInfo.fromJson(json);
  }
}
/**
 * 
 curl \
  'https://youtube.googleapis.com/youtube/v3/channels?part=contentDetails%2C%20snippet%2C%20statistics&id=UCcElHdSOozW8xsRW0VY4isw&access_token=AIzaSyD7IrPDBkPf1pbDTNLpaM32gqFghToy71U&key=[YOUR_API_KEY]' \
  --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
  --header 'Accept: application/json' \
  --compressed

 */
