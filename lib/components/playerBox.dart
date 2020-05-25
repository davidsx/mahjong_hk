import 'package:flutter/material.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/models/player.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/resources/responsive.dart';
import 'package:mahjong/view/alertBox.dart';
import 'package:mahjong/view/questionBox.dart';
import 'package:mahjong/view/skeleton.dart';
import 'package:provider/provider.dart';

class TablePlayerBox extends StatefulWidget {
  TablePlayerBox(this.playerIndex, this.controller);
  final int playerIndex;
  final AnimationController controller;

  @override
  _TablePlayerBoxState createState() => _TablePlayerBoxState();
}

class _TablePlayerBoxState extends State<TablePlayerBox> {
  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<MJProvider>(context);
    final theme = ResponsiveTheme(MediaQuery.of(context).size);

    final TableState state = tableProvider.state;
    final Player player = tableProvider.table.players[widget.playerIndex];
    final bool isWinner = tableProvider.isWaiting &&
        tableProvider.tmpWinner.isNotEmpty &&
        tableProvider.tmpWinner == player.name;
    final bool isLoser =
        tableProvider.isWaiting && tableProvider.tmpLoser.contains(player.name);
    final bool isLeaving = tableProvider.isSwitching &&
        tableProvider.tmpPlayerToLeave.isNotEmpty &&
        tableProvider.tmpPlayerToLeave == player.name;
    return FractionallySizedBox(
      widthFactor: 1 / 3,
      child: AspectRatio(
        aspectRatio: 1,
        child: Material(
          color: transparent,
          shadowColor: transparent,
          elevation: 10,
          child: Container(
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: tableProvider.isSwitching
                    ? isLeaving ? blue : blue.withOpacity(0.3)
                    : isWinner ? green : isLoser ? red : transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(0.1),
                  blurRadius: isWinner || isLoser ? 15 : 10,
                ),
              ],
            ),
            child: TransparentInkWell(
              onLongPress: () {
                if (state == TableState.WaitingWinner) {
                  tableProvider.winnerFound(player.name, true);
                  showRuleset();
                } else if (state == TableState.WaitingLoser && !isWinner) {
                  tableProvider.loserFound(player.name, true);
                  showRuleset();
                }
              },
              onTap: () {
                if (state == TableState.SettingStarter) {
                  tableProvider.setStarter(player.name);
                } else if (state == TableState.WaitingWinner) {
                  tableProvider.winnerFound(player.name);
                } else if (state == TableState.WaitingLoser) {
                  isWinner
                      ? tableProvider.winnerFound(player.name, true)
                      : tableProvider.loserFound(player.name);
                  showRuleset();
                } else if (state == TableState.SwitchingPlayerLeave) {
                  tableProvider.playerLeaveFound(player.name);
                  showSwitchPlayer();
                } else if (state == TableState.HandlingEvent) {
                  switch (widget.playerIndex) {
                    case 0:
                      newGame();
                      break;
                    case 1:
                      reviseLastRound();
                      break;
                    case 2:
                      restartGame();
                      break;
                    case 3:
                      tableProvider.switchPlayer();
                      widget.controller.reverse();
                      break;
                  }
                }
              },
              onDoubleTap: () {
                if (state == TableState.WaitingWinner) {
                  tableProvider.winnerFound(player.name, true);
                  showRuleset();
                } else if (state == TableState.WaitingLoser) {
                  isWinner
                      ? tableProvider.winnerFound(player.name, true)
                      : tableProvider.loserFound(player.name);
                  showRuleset();
                }
              },
              child: Stack(
                children: <Widget>[
                  if (tableProvider.isLoading)
                    Skeleton(
                      height: double.infinity,
                      width: double.infinity,
                      borderRadius: 20.0,
                    )
                  else if (tableProvider.isHandlingEvent)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            [
                              Icons.add,
                              Icons.reply,
                              Icons.replay,
                              Icons.swap_vert
                            ][widget.playerIndex],
                            color: greenLight,
                            size: theme.headline1,
                          ),
                          Text(
                            ["開新牌局", "刪除上局", "重新開始", "換人"][widget.playerIndex],
                            style: TextStyle(
                              fontSize: theme.overline,
                              color: greenLight,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (tableProvider.isWaiting ||
                      tableProvider.isSetting ||
                      tableProvider.isSwitching ||
                      tableProvider.isGameEnd)
                    Center(
                      child: Stack(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment(0, -0.15),
                            child: FractionallySizedBox(
                              widthFactor: 0.9,
                              heightFactor: 0.3,
                              child: FittedBox(
                                child: Text(
                                  player.name,
                                  style: TextStyle(
                                    fontSize: theme.headline2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0, 0.5),
                            child: Text(
                              "${player.balance}",
                              style: TextStyle(
                                fontSize: theme.subtitle1,
                                color: !player.active
                                    ? white
                                    : player.balance == 0
                                        ? grey
                                        : player.balance > 0
                                            ? greenDark
                                            : player.balance < 0
                                                ? redDark
                                                : black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (state == TableState.SettingStarter &&
                      tableProvider.table.dealer < 0)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(7.5),
                        child: Text(
                          "莊",
                          style: TextStyle(
                            color: grey.withOpacity(0.5),
                            fontSize: theme.body1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    )
                  else if ((tableProvider.isWaiting ||
                          state == TableState.SettingReady) &&
                      tableProvider.table.dealer ==
                          tableProvider.table.players
                              .indexWhere((p) => p.name == player.name))
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "莊",
                          style: TextStyle(
                            color: redLight,
                            fontSize: theme.caption,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if ((tableProvider.isWaiting ||
                          state == TableState.SettingReady) &&
                      tableProvider.table.starter ==
                          tableProvider.table.players
                              .indexWhere((p) => p.name == player.name))
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Text(
                          "起莊",
                          style: TextStyle(
                            color: grey.withOpacity(0.8),
                            fontSize: theme.overline,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showRuleset() {
    // print(Globals().ruleSet);
    final tableProvider = Provider.of<MJProvider>(context, listen: false);
    List<int> ruleset =
        List<int>.generate(tableProvider.table.ruleIndex - 2, (i) => i + 3);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      for (int i = 0; i < ruleset.length; i++)
                        FractionallySizedBox(
                          widthFactor: 1 / 3,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: TransparentInkWell(
                              onTap: () {
                                tableProvider.ruleSetFound(ruleset[i]);
                                Navigator.pop(dialogContext);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: transparent,
                                  border: Border(
                                    right: BorderSide(
                                        color: (i + 1) % 3 != 0
                                            ? grey
                                            : transparent),
                                    bottom: BorderSide(
                                        color: (ruleset.length -
                                                    ruleset.length % 3) >
                                                i
                                            ? grey
                                            : transparent),
                                  ),
                                  // borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        "${ruleset[i]}",
                                        style: TextStyle(fontSize: 50),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment(0.6, 0.6),
                                      child: Text(
                                        "番",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Divider(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                        height: 50,
                        child: FlatButton(
                          child: Text(
                            "取消",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: blueLight,
                            ),
                          ),
                          onPressed: () {
                            tableProvider.cancelRound();
                            Navigator.pop(dialogContext);
                          },
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }

  showSwitchPlayer() {
    final tableProvider = Provider.of<MJProvider>(context, listen: false);
    return showDialog(
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

  reviseLastRound() {
    final tableProvider = Provider.of<MJProvider>(context, listen: false);
    bool lastRoundSwitched = tableProvider.table.rounds.last.isSwitchPlayer;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertBox(
          title: lastRoundSwitched ? "取消換人？" : "刪除上局？",
          yes: '係呀',
          no: '唔係',
          action: () {
            lastRoundSwitched
                ? tableProvider.reviseLastSwitch()
                : tableProvider.reviseLastRound();
            Navigator.pop(dialogContext);
            widget.controller.reverse();
          },
        );
      },
    );
  }

  restartGame() {
    final tableProvider = Provider.of<MJProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertBox(
          title: "重新開始？",
          subtitle: tableProvider.table.isPlayerSwitched ? "(以換人後的玩家重開新局)" : "",
          yes: '係呀',
          no: '唔係',
          action: () {
            tableProvider.restartTable();
            Navigator.pop(dialogContext);
            widget.controller.reverse();
          },
        );
      },
    );
  }

  newGame() {
    final tableProvider = Provider.of<MJProvider>(context, listen: false);
    if (tableProvider.isLoading) {
      tableProvider.newTable();
      Navigator.of(context).pushReplacementNamed('/rule');
    } else {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertBox(
            title: "開新牌局？",
            yes: '係呀',
            no: '唔係',
            subtitle: "現有牌局可於歷史查閱",
            action: () async {
              // playerProvider.deactivateAllPllayer();
              tableProvider.newTable();
              Navigator.pop(dialogContext);
              Navigator.of(dialogContext).pushReplacementNamed('/rule');
            },
          );
        },
      );
    }
  }
}
