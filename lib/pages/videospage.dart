import 'package:flutter/material.dart';

import 'package:youtube_api/models/videos_model.dart';
import 'package:youtube_api/services/responceHandeller.dart';

import '../constants.dart';

class VideoPage extends StatefulWidget {
  final String playlistId;
  const VideoPage({Key? key, required this.playlistId}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final _responcehandeller = ResponceHandeller();
  late VideosInfo _responce;
  late bool _loading;

  void getResponce(String playlistId) async {
    final result = await _responcehandeller.getVideosInfo(playlistId);
    setState(() {
      _responce = result;
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading = true;

    getResponce(widget.playlistId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('YouTube'),
      ),
      body: _loading ? CircularProgressIndicator() : videoBox(_responce),
    );
  }
}

Widget videoBox(VideosInfo _responce) {
  return ListView.builder(
    itemCount: _responce.items.length,
    itemBuilder: (BuildContext context, index) => Column(
      children: [
        Container(
          height: 110,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kPrimaryColor,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: kSecondaryColor,
                  child: Image.network(
                    _responce.items[index].snippet.thumbnails.high.url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: _responce.items[index].snippet.title,
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        _responce.items[index].snippet.videoOwnerChannelTitle,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 12, color: kSecondaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: IconButton(
                    alignment: Alignment.topRight,
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      color: kSecondaryColor,
                    )),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
