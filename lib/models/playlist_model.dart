// To parse this JSON data, do
//
//     final playlistInfo = playlistInfoFromJson(jsonString);

import 'dart:convert';

PlaylistInfo playlistInfoFromJson(String str) =>
    PlaylistInfo.fromJson(json.decode(str));

String playlistInfoToJson(PlaylistInfo data) => json.encode(data.toJson());

class PlaylistInfo {
  PlaylistInfo({
    required this.kind,
    required this.etag,
    required this.pageInfo,
    required this.items,
  });

  String kind;
  String etag;
  PageInfo pageInfo;
  List<Item> items;

  factory PlaylistInfo.fromJson(Map<String, dynamic> json) => PlaylistInfo(
        kind: json["kind"],
        etag: json["etag"],
        pageInfo: PageInfo.fromJson(json["pageInfo"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "pageInfo": pageInfo.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet,
    required this.contentDetails,
  });

  String kind;
  String etag;
  String id;
  Snippet snippet;
  ContentDetails contentDetails;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        kind: json["kind"],
        etag: json["etag"],
        id: json["id"],
        snippet: Snippet.fromJson(json["snippet"]),
        contentDetails: ContentDetails.fromJson(json["contentDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "id": id,
        "snippet": snippet.toJson(),
        "contentDetails": contentDetails.toJson(),
      };
}

class ContentDetails {
  ContentDetails({
    required this.itemCount,
  });

  int itemCount;

  factory ContentDetails.fromJson(Map<String, dynamic> json) => ContentDetails(
        itemCount: json["itemCount"],
      );

  Map<String, dynamic> toJson() => {
        "itemCount": itemCount,
      };
}

class Snippet {
  Snippet({
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.channelTitle,
    required this.localized,
    required this.thumbnailUrl,
  });

  DateTime publishedAt;
  String channelId;
  String title;
  String description;
  String channelTitle;
  Localized localized;
  String thumbnailUrl;

  factory Snippet.fromJson(Map<String, dynamic> json) => Snippet(
        publishedAt: DateTime.parse(json["publishedAt"]),
        channelId: json["channelId"],
        title: json["title"],
        description: json["description"],
        channelTitle: json["channelTitle"],
        localized: Localized.fromJson(json["localized"]),
       thumbnailUrl: json['thumbnails']['high']['url']??"",
      );

  Map<String, dynamic> toJson() => {
        "publishedAt": publishedAt.toIso8601String(),
        "channelId": channelId,
        "title": title,
        "description": description,
        "channelTitle": channelTitle,
        "localized": localized.toJson(),
      };
}

class Localized {
  Localized({
    required this.title,
    required this.description,
  });

  String title;
  String description;

  factory Localized.fromJson(Map<String, dynamic> json) => Localized(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}

class PageInfo {
  PageInfo({
    required this.totalResults,
    required this.resultsPerPage,
  });

  int totalResults;
  int resultsPerPage;

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        totalResults: json["totalResults"],
        resultsPerPage: json["resultsPerPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalResults": totalResults,
        "resultsPerPage": resultsPerPage,
      };
}
