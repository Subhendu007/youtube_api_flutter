import 'package:flutter/material.dart';
import 'package:youtube_api/models/playlist_model.dart';
import 'package:youtube_api/pages/videospage.dart';
import 'package:youtube_api/services/responceHandeller.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _responcehandeller = ResponceHandeller();
  late PlaylistInfo _responce;
  late bool _loading;

  void getResponce() async {
    final result = await _responcehandeller.getPlaylistInfo();
    setState(() {
      _responce = result;
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading = true;

    getResponce();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('YouTube'),
        ),
        body: _loading ? CircularProgressIndicator() : playlistBox(_responce));
  }
}

Widget playlistBox(PlaylistInfo _responce) {
  return ListView.builder(
      itemCount: _responce.items.length,
      itemBuilder: (BuildContext context, index) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VideoPage(playlistId: _responce.items[index].id),
            ),
          ),
          child: Container(
            height: 130,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: listShadow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.green,
                      ),
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
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
                        _responce.items[index].snippet.channelTitle,
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 12,
                          fontFamily: 'Poppins Light',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: kSecondaryColor,
                ),
              ],
            ),
          ),
        );
      });
}
