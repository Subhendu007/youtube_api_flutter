import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:youtube_api/models/channel_model.dart';
import 'package:youtube_api/models/videos.dart';
import 'package:youtube_api/services/responceHandeller.dart';
import '../constants.dart';

class VideoPage extends StatefulWidget {
  final String playlistId;
  final String videoCount;
  const VideoPage(
      {Key? key, required this.playlistId, required this.videoCount})
      : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final _responceHandeller = ResponceHandeller();
  late ChannelInfo _channelInfo;
  late bool _loding;
  bool _isLoding = false;

  _initChannel() async {
    ChannelInfo channelInfo =
        await _responceHandeller.getChannelInfo(playlistId: widget.playlistId);
    setState(() {
      _channelInfo = channelInfo;
      _loding = false;
    });
  }

  _lodeMoreVideos() async {
    _isLoding = true;
    List<Video?> moreVideos =
        await _responceHandeller.getVideosInfo(playlistId: widget.playlistId);
    List<Video?> allVideos = _channelInfo.videos!..addAll(moreVideos);
    setState(() {
      _channelInfo.videos = allVideos;
    });
    _isLoding = false;
  }

  @override
  void initState() {
    _loding = true;
    _initChannel();
    super.initState();
  }

  _buildVideo(Video video) {
    return Column(
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
                    video.thumbnailUrl,
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
                            text: video.title,
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
                        video.channelTitle,
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
                    onPressed: () {
                      Share.share(
                          'https://www.youtube.com/watch?v=${video.id}');
                    },
                    icon: Icon(
                      Icons.share,
                      color: kSecondaryColor,
                    )),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('YouTube'),
      ),
      body: _loding
          ? LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.red),
            )
          : _channelInfo.videos!.length != 0
              ? NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollDetails) {
                    if (!_isLoding &&
                        _channelInfo.videos!.length <=
                            int.parse(widget.videoCount) - 2 &&
                        scrollDetails.metrics.pixels ==
                            scrollDetails.metrics.maxScrollExtent) {
                      CircularProgressIndicator();
                      _lodeMoreVideos();
                    }
                    return false;
                  },
                  child: ListView.builder(
                      itemCount: 1 + _channelInfo.videos!.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Container();
                        }
                        Video? video = _channelInfo.videos![index - 1];
                        return _buildVideo(video!);
                      }),
                )
              : Center(
                  child: Text(
                    'No Videos Found',
                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey),
                  ),
                ),
    );
  }
}
