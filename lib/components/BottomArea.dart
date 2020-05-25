import 'package:flutter/material.dart';
import 'package:mahjong/components/playerHistory.dart';
import 'package:mahjong/components/playerList.dart';
import 'package:mahjong/components/tableDetail.dart';
import 'package:mahjong/extensions/CustomRaisedButton.dart';
import 'package:mahjong/models/globals.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/resources/responsive.dart';
import 'package:mahjong/view/alertBox.dart';
import 'package:mahjong/view/questionBox.dart';
import 'package:provider/provider.dart';

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
    final tableProvider = Provider.of<MJProvider>(context);
    final theme = ResponsiveTheme(MediaQuery.of(context).size);

    return Stack(
      children: <Widget>[
        if (tableProvider.state == TableState.SettingStarter)
          Center(
            child: Text(
              "選擇起莊",
              style: TextStyle(fontSize: 30.0),
            ),
          )
        else if (tableProvider.state == TableState.SettingReady)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "準備齊腳開枱",
                  style: TextStyle(fontSize: 30.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CustomRaisedButton(
                        context,
                        color: white.withOpacity(0.9),
                        subcolor: white.withOpacity(0.5),
                        text: '重選',
                        onPressed: () => tableProvider.resetStarter(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CustomRaisedButton(
                        context,
                        color: greenLight.withOpacity(0.9),
                        subcolor: greenLight.withOpacity(0.5),
                        text: '開枱',
                        onPressed: () => tableProvider.startGame(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        else if (tableProvider.isPlaying || tableProvider.isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Expanded(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (tableProvider.state == TableState.WaitingWinner ||
                        tableProvider.isHandlingEvent)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: CustomRaisedButton(
                          context,
                          color: white.withOpacity(0.9),
                          subcolor: white.withOpacity(0.5),
                          text: '流局',
                          onPressed:
                              tableProvider.state == TableState.WaitingWinner
                                  ? () => showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return AlertBox(
                                            title: "無人食糊？",
                                            yes: '係呀',
                                            no: '唔係',
                                            action: () {
                                              tableProvider.emptyRound();
                                              Navigator.pop(dialogContext);
                                            },
                                          );
                                        },
                                      )
                                  : null,
                        ),
                      ),
                    if (tableProvider.isWaiting &&
                        tableProvider.state != TableState.WaitingWinner)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: CustomRaisedButton(
                          context,
                          color: white.withOpacity(0.9),
                          subcolor: white.withOpacity(0.5),
                          text: '取消',
                          onPressed: tableProvider.isWaiting &&
                                  tableProvider.state !=
                                      TableState.WaitingWinner
                              ? () => tableProvider.cancelRound()
                              : null,
                        ),
                      ),
                    if (tableProvider.isWaiting &&
                        tableProvider.state != TableState.WaitingWinner)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: CustomRaisedButton(
                          context,
                          color: greenLight.withOpacity(0.9),
                          subcolor: greenLight.withOpacity(0.5),
                          text: '確定',
                          onPressed:
                              tableProvider.state == TableState.WaitingConfirm
                                  ? () => tableProvider.roundConfirm()
                                  : null,
                        ),
                      ),
                  ],
                ),
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
                            fontSize: theme.overline,
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
                            fontSize: theme.overline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else if (tableProvider.isSwitching)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
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
                            tableProvider.tmpPlayerToLeave,
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
                            tableProvider.tmpPlayerToAdd,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 50.0),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox.fromSize(
                  size: Size.fromHeight(20),
                  child: Text(
                    tableProvider.errMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: red),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomRaisedButton(
                      context,
                      color: white.withOpacity(0.9),
                      subcolor: white.withOpacity(0.5),
                      text: '取消',
                      onPressed: tableProvider.isSwitching
                          ? () => tableProvider.cancelSwitchPlayer()
                          : null,
                    ),
                    CustomRaisedButton(
                      context,
                      color: blueLight.withOpacity(0.7),
                      subcolor: blueLight.withOpacity(0.3),
                      text: '轉名',
                      onPressed: tableProvider.state ==
                              TableState.SwitchingPlayerConfirm
                          ? () {
                              tableProvider.undoPlayerAdd();
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return QuestionBox(
                                    title: "換人",
                                    placeholder: ['名稱'],
                                    maxLength: [4],
                                    yes: '確定',
                                    no: '取消',
                                    action: (list) {
                                      tableProvider.playerAddFound(list[0]);
                                    },
                                    cancelAction: () {
                                      tableProvider.undoPlayerLeave();
                                    },
                                  );
                                },
                              );
                            }
                          : null,
                    ),
                    CustomRaisedButton(
                      context,
                      color: greenLight.withOpacity(0.9),
                      subcolor: greenLight.withOpacity(0.5),
                      text: '確定',
                      onPressed: tableProvider.state ==
                              TableState.SwitchingPlayerConfirm
                          ? () => tableProvider.confirmSwitchPlayer()
                          : null,
                    ),
                  ]
                      .map((w) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7.0,
                            vertical: 10.0,
                          ),
                          child: w))
                      .toList(),
                ),
              ],
            ),
          )
        else if (tableProvider.isGameEnd)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "完",
                  style: TextStyle(fontSize: 30.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: CustomRaisedButton(
                    context,
                    color: white.withOpacity(0.9),
                    subcolor: white.withOpacity(0.5),
                    text: '執位',
                    onPressed: () => tableProvider.rearrangeSeat(),
                  ),
                ),
              ],
            ),
          )
        else if (tableProvider.state == TableState.RearrageSeat)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: PlayerList(Globals().lastPlayers),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, right: 10.0),
                    child: CustomRaisedButton(
                      context,
                      color: white.withOpacity(0.9),
                      subcolor: white.withOpacity(0.5),
                      text: '重選',
                      onPressed: !tableProvider.table.isPlayerEmpty
                          ? () => tableProvider.removeAllPlayer()
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                    child: CustomRaisedButton(
                      context,
                      color: greenLight.withOpacity(0.9),
                      subcolor: greenLight.withOpacity(0.5),
                      text: '開枱',
                      onPressed: tableProvider.table.isPlayerReady
                          ? () => tableProvider.continueGame()
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          )
      ],
    );
  }
}
