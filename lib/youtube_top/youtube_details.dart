import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_new_mytube_app/tabBarControll/tabBarControll.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeDetailsPage extends StatefulWidget {
  var reservationList, watchedCount, watchedVideoLength;
  YoutubeDetailsPage(
      {Key key,
      @required this.reservationList,
      this.watchedCount,
      this.watchedVideoLength})
      : super(key: key);
  @override
  _YoutubeDetailsPageState createState() => _YoutubeDetailsPageState();
}

class _YoutubeDetailsPageState extends State<YoutubeDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  YoutubeMetaData _videoMetaData;

  bool _isPlayerReady = false;
  int watchedCount;

  @override
  void initState() {
    super.initState();
    watchedCount = widget.watchedCount;
    _controller = YoutubePlayerController(
      initialVideoId: widget.reservationList[watchedCount],
      flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: true,
          enableCaption: true,
          captionLanguage: 'ja'),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_videoMetaData.title);
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Color(0xFF2D89AD),
          progressColors: ProgressBarColors(backgroundColor: Color(0xFF2D89AD)),
          topActions: <Widget>[
            const SizedBox(width: 6.0),
            Expanded(
              child: Text(
                _controller.metadata.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
          onReady: () {
            _isPlayerReady = true;
          },
          onEnded: (end) {
            watchedCount += 1;
            if (watchedCount == widget.watchedVideoLength) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TabBarControll()));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => YoutubeDetailsPage(
                          reservationList: widget.reservationList,
                          watchedCount: watchedCount,
                          watchedVideoLength: widget.watchedVideoLength)));
            }
          }),
      builder: (context, player) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'video keeper',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _space,
                  _text('タイトル', _videoMetaData.title),
                  _space,
                  _text('チャンネル', _videoMetaData.author),
                  _space,
                ],
              ),
            ),
            _space,
            Center(
              child: Column(
                children: [
                  SizedBox(
                      width: 260,
                      height: 46,
                      child: RaisedButton(
                        child: Text("次の動画へ",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        color: Color(0xFF2D89AD),
                        shape: StadiumBorder(),
                        onPressed: () {
                          watchedCount += 1;
                          if (watchedCount == widget.watchedVideoLength) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TabBarControll()));
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => YoutubeDetailsPage(
                                        reservationList: widget.reservationList,
                                        watchedCount: watchedCount,
                                        watchedVideoLength:
                                            widget.watchedVideoLength)));
                          }
                        },
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
