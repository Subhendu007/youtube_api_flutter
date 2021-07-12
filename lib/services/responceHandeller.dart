import 'dart:convert';

import 'package:youtube_api/keys.dart';
import 'package:youtube_api/models/channel_model.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api/models/playlist_model.dart';
import 'package:youtube_api/models/videos.dart';

class ResponceHandeller {
  String _nextPageToken = '';

  Future<List<Video?>> getVideosInfo({required String playlistId}) async {
    final queryParameters = {
      'part': 'contentDetails, id, snippet, status',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': Keys.API_KEY,
    };
    Uri uri = Uri.https(
        'youtube.googleapis.com', '/youtube/v3/playlistItems', queryParameters);

    //getiitng playlist videosJson
    var responce = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Authorization': Keys.ACCESS_TOKEN
    });
    if (responce.statusCode == 200 && jsonDecode(responce.body) != null) {
      var json = jsonDecode(responce.body);
      
      _nextPageToken = json['nextPageToken'] ?? '';

      List<dynamic> videosJson = json['items'];
      List<Video?> videos = [];

      //fetching first page videos
      for (int i = 0; i < videosJson.length; i++) {
        //if (videosJson[i]['status']['privacyStatus'] == 'public') {
          videos.add(Video.fromMap(videosJson[i]['snippet']));
        //}
      }
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
    final responce =
        await http.get(uri, headers: {'Accept': 'application/json'});
    if (responce.statusCode == 200 && jsonDecode(responce.body) != null) {
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
      'maxResults': '50',
      'channelId': Keys.CHANNEL_ID,
      'key': Keys.API_KEY,
    };
    Uri uri = Uri.https(
        'youtube.googleapis.com', '/youtube/v3/playlists', queryParameters);
    final responce =
        await http.get(uri, headers: {'Accept': 'application/json'});
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
