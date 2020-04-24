import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahjong/components/playerHistory.dart';
import 'package:mahjong/components/playerList.dart';
import 'package:mahjong/components/playerTable.dart';
import 'package:mahjong/components/tableDetail.dart';
import 'package:mahjong/models/globals.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/view/tableAppBar.dart';
import 'package:mahjong/view/tableDrawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MjProvider>(
      builder: (context, value, child) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              // if (!value.isLoading)
              SafeArea(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TableAppBar(),
                      TableBox(),
                      Expanded(flex: 3, child: BottomArea()),
                    ],
                  ),
                ),
              ),
            ],
          ),
          drawer: TableDrawer(scaffoldContext: context),
        );
      },
    );
  }
}

class BottomArea extends StatefulWidget {
  @override
  _BottomAreaState createState() => _BottomAreaState();
}

class _BottomAreaState extends State<BottomArea> {
  PageController pageController;
  int _page;
  @override
  void initState() {
    super.initState();
    pageController = new PageController();
    _page = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MjProvider>(
      builder: (context, value, child) {
        if (value.state == TableState.SettingStarter) {
          return Center(
            child: Text(
              "選擇起莊",
              style: TextStyle(fontSize: 30.0),
            ),
          );
        } else if (value.state == TableState.SettingReady) {
          return Center(
            child: Text(
              "準備齊腳開枱",
              style: TextStyle(fontSize: 30.0),
            ),
          );
        } else if (value.isWaiting || value.isLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "牌局詳情",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: _page == 0 ? black.withOpacity(0.8) : grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                          color: _page == 0 ? black : grey,
                          shape: BoxShape.circle,
                        ),
                        width: 7.5,
                        height: 7.5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                          color: _page == 1 ? black : grey,
                          shape: BoxShape.circle,
                        ),
                        width: 7.5,
                        height: 7.5,
                      ),
                      Expanded(
                        child: Text(
                          "牌局歷史",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: _page == 1 ? black.withOpacity(0.8) : grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _page = page;
                      });
                    },
                    children: <Widget>[
                      TableDetail(),
                      PlayerHistory(),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (value.isSwitching) {
          return Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "離開",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        value.tmpPlayerToLeave,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 50.0),
                      ),
                    ],
                  ),
                ),
                Center(child: Icon(Icons.arrow_forward)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "加入",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        value.tmpPlayerToAdd,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 50.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        } else if (value.state == TableState.GameEnd) {
          return Center(
            child: Text(
              "完",
              style: TextStyle(fontSize: 30.0),
            ),
          );
        } else if (value.state == TableState.RearrageSeat) {
          return AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: PlayerList(Globals().lastPlayers),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
