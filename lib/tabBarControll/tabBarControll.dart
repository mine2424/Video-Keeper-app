import 'package:flutter/material.dart';
import 'package:flutter_new_mytube_app/home/home.dart';
import 'package:flutter_new_mytube_app/setting/setting.dart';
import 'package:flutter_new_mytube_app/youtube_alarm/alerm_setting.dart';
import 'package:flutter_new_mytube_app/youtube_top/youtubeTop.dart';

class TabBarControll extends StatefulWidget {
  @override
  _TabBarControllState createState() => _TabBarControllState();
}

class _TabBarControllState extends State<TabBarControll> {
  TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF2D89AD),
            leading: Container(),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.white.withOpacity(0.5),
                  unselectedLabelStyle: TextStyle(fontSize: 13.0),
                  labelColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 16.0),
                  indicatorColor: Colors.white,
                  indicatorWeight: 2.0,
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'home'),
                    Tab(text: 'alarm'),
                    Tab(text: 'other'),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [HomePage(), YoutubeAlarm(), Setting()],
          ),
        ),
      ),
    );
  }
}
