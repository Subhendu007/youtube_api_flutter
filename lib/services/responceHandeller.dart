import 'dart:convert';

import 'package:youtube_api/keys.dart';
import 'package:youtube_api/models/channel_model.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api/models/playlist_model.dart';
import 'package:youtube_api/models/videos_model.dart';

class ResponceHandeller {
  Future<ChannelInfo> getChannelInfo() async {
    final queryParameters = {
      'part': 'contentDetails, snippet, statistics',
      'id': Keys.CHANNEL_ID,
      'key': Keys.API_KEY,
    };
    Uri uri = Uri.https(
        'youtube.googleapis.com', '/youtube/v3/channels', queryParameters);
    final responce = await http.get(uri);
    final json = jsonDecode(responce.body);
    return ChannelInfo.fromJson(json);
  }

  Future<PlaylistInfo> getPlaylistInfo() async {
    final queryParameters = {
      'part': 'id, snippet, contentDetails',
      'channelId': Keys.CHANNEL_ID,
      'key': Keys.API_KEY,
    };
    Uri uri = Uri.https(
        'youtube.googleapis.com', '/youtube/v3/playlists', queryParameters);
    final responce = await http.get(uri);
    final json = jsonDecode(responce.body);
    return PlaylistInfo.fromJson(json);
  }

  Future<VideosInfo> getVideosInfo(String playlistId) async {
    final queryParameters = {
      'part': 'snippet, contentDetails',
      'playlistId': playlistId,
      'key': Keys.API_KEY,
    };
    Uri uri = Uri.https(
        'youtube.googleapis.com', '/youtube/v3/playlistItems', queryParameters);
    final responce = await http.get(uri);
    final json = jsonDecode(responce.body);

    return VideosInfo.fromJson(json);
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
