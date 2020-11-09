import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_mytube_app/services/youtubeKey.dart';
import 'package:flutter_new_mytube_app/youtube_top/youtube_details.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class YoutubeTopPage extends StatefulWidget {
  var videoCount, message;
  YoutubeTopPage({Key key, @required this.videoCount, this.message})
      : super(key: key);
  @override
  _YoutubeTopPageState createState() => _YoutubeTopPageState();
}

class _YoutubeTopPageState extends State<YoutubeTopPage> {
  bool recordsLoaded = false;
  static int maxResults = 25;
  int count = 0;
  List youtubeIdList = [];
//  static String videosType = "channel";
// static String videosType = "playlist";
  static String videosType = "videos";

  YoutubeAPI ytApi = new YoutubeAPI(
    API_KEY,
    maxResults: maxResults,
    type: videosType,
  );
  List<YT_API> ytResult = [];

  callAPI(searchQuery) async {
    print('UI callled');
    //  CircularProgressIndicator();
    String query = searchQuery;
    ytResult = await ytApi.search(query);
    setState(() {
      print('UI Updated 2');
      recordsLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    recordsLoaded = false;
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ja', timeago.FrMessages());
    // timeago.setLocaleMessages('en', timeago.EnMessages());
    // var locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _clayContainer(
                childs: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text('検索'),
                      Text((int.parse(widget.videoCount) - count).toString() +
                          '本まで選択できます'),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search videos',
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        onSubmitted: (searchQuery) {
                          callAPI(searchQuery);
                        },
                      )
                    ],
                  ),
                ),
                height: 0.25,
                width: 0.8),
            Container(
                child: recordsLoaded
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: ytResult.length,
                        itemBuilder: (_, int index) => listItem(index))
                    : Center(
                        child: Container(
                          child: const Text('What\'up?'),
                        ),
                      )),
          ],
        ),
      ),
    );
  }

  Widget listItem(index) {
    var publishedAt =
        timeago.format(DateTime.parse(ytResult[index].publishedAt));
    return Card(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7.0),
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: <Widget>[
            InkWell(
              child: CachedNetworkImage(
                imageUrl: ytResult[index].thumbnail['default']['url'],
                width: 90,
                height: 90,
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 10.0)),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  InkWell(
                    child: Text(
                      ytResult[index].title,
                      softWrap: true,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onTap: () {
                      print(ytResult[index].url);
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('確認'),
                            content: SingleChildScrollView(
                              child: Center(
                                child: Text('この動画を追加しますか？'),
                              ),
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('キャンセル')),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    sendVideoReservation(ytResult[index].url);
                                  },
                                  child: Text('OK'))
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 1.5)),
                  Text(
                    ytResult[index].channelTitle,
                    softWrap: true,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 3.0)),
                  Text(
                    publishedAt,
                    softWrap: true,
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ]))
          ],
        ),
      ),
    );
  }

  Widget _clayContainer({Widget childs, double height, double width}) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: ClayContainer(
        height: MediaQuery.of(context).size.height * height,
        width: MediaQuery.of(context).size.width * width,
        depth: 12,
        spread: 12,
        borderRadius: 16,
        color: Color(0xFFF2F2F2),
        child: childs,
      ),
    ));
  }

  Future<void> sendVideoReservation(id) async {
    youtubeIdList.add(id.toString().substring(32));
    setState(() {
      count = count + 1;
    });
    if (count == int.parse(widget.videoCount)) {
      final _firebaseAuth = FirebaseAuth.instance.currentUser.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseAuth)
          .collection('youtubeReservationList')
          .doc()
          .set({
        'videoList': youtubeIdList,
        'createAt': Timestamp.now(),
        'sumTime': youtubeIdList.length,
        'message': widget.message
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => YoutubeDetailsPage(
                  reservationList: youtubeIdList,
                  watchedCount: 0,
                  watchedVideoLength: youtubeIdList.length)));
      print('youtubeIdList sent firestore');
      // youtubeIdList = [];
    }
    print(youtubeIdList);
  }
}
