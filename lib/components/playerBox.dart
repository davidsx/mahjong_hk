import 'package:flutter/material.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/models/player.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/view/questionBox.dart';
import 'package:mahjong/view/skeleton.dart';
import 'package:provider/provider.dart';

class TablePlayerBox extends StatefulWidget {
  TablePlayerBox(this.playerIndex);
  final int playerIndex;

  @override
  _TablePlayerBoxState createState() => _TablePlayerBoxState();
}

class _TablePlayerBoxState extends State<TablePlayerBox> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1 / 3,
      child: AspectRatio(
        aspectRatio: 1,
        child: Consumer<MjProvider>(
          builder: (context, value, child) {
            final TableState state = value.state;
            final Player player = value.table.players[widget.playerIndex];
            final bool isWinner = value.isWaiting &&
                value.tmpWinner.isNotEmpty &&
                value.tmpWinner == player.name;
            final bool isLoser =
                value.isWaiting && value.tmpLoser.contains(player.name);
            final bool isLeaving = value.isSwitching &&
                value.tmpPlayerToLeave.isNotEmpty &&
                value.tmpPlayerToLeave == player.name;
            return TransparentInkWell(
              onLongPress: () {
                if (state == TableState.WaitingWinner) {
                  value.winnerFound(player.name, true);
                  showRuleset();
                } else if (state == TableState.WaitingLoser && !isWinner) {
                  value.loserFound(player.name, true);
                  showRuleset();
                }
              },
              onTap: () {
                if (state == TableState.SettingStarter) {
                  value.setStarter(player.name);
                } else if (state == TableState.WaitingWinner) {
                  value.winnerFound(player.name);
                } else if (state == TableState.WaitingLoser) {
                  isWinner
                      ? value.winnerFound(player.name, true)
                      : value.loserFound(player.name);
                  showRuleset();
                } else if (state == TableState.SwitchingPlayerLeave) {
                  value.playerLeaveFound(player.name);
                  showSwitchPlayer();
                }
              },
              child: Material(
                color: transparent,
                shadowColor: transparent,
                elevation: 10,
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: value.isSwitching
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
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment(0.0, -0.35),
                        child: value.isLoading
                            ? Skeleton(height: 30, width: 60)
                            : Text(
                                player.name,
                                style: TextStyle(fontSize: 30),
                              ),
                      ),
                      Align(
                        alignment: Alignment(0.0, 0.65),
                        child: value.isLoading
                            ? Skeleton(height: 30, width: 90)
                            : Text(
                                "${player.balance}",
                                style: TextStyle(
                                  fontSize: 30,
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
                      if (state == TableState.SettingStarter &&
                          value.table.dealer < 0)
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(7.5),
                            child: Text(
                              "莊",
                              style: TextStyle(
                                color: grey.withOpacity(0.5),
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        )
                      else if ((value.isWaiting ||
                              state == TableState.SettingReady) &&
                          value.table.dealer ==
                              value.table.players
                                  .indexWhere((p) => p.name == player.name))
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "莊",
                              style: TextStyle(
                                color: redLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      if ((value.isWaiting ||
                              state == TableState.SettingReady) &&
                          value.table.starter ==
                              value.table.players
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
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  showRuleset() {
    // print(Globals().ruleSet);
    final tableProvider = Provider.of<MjProvider>(context, listen: false);
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
            content: AspectRatio(
              aspectRatio: 3 / ((ruleset.length / 3).ceil() + 1),
              child: Container(
                width: double.infinity,
                // height: ((ruleset.length / 3).ceil() * 60).toDouble(),
                height: double.infinity,
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        children: <Widget>[
                          for (int i = 0; i < ruleset.length; i++)
                            TransparentInkWell(
                              onTap: () {
                                tableProvider.ruleSetFound(ruleset[i]);
                                Navigator.pop(dialogContext);
                              },
                              child: Material(
                                color: transparent,
                                shadowColor: transparent,
                                elevation: 10,
                                child: Container(
                                  margin: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // borderRadius: BorderRadius.only(
                                    //   topLeft: i == 0
                                    //       ? Radius.circular(30)
                                    //       : Radius.zero,
                                    //   topRight: i == 2
                                    //       ? Radius.circular(30)
                                    //       : Radius.zero,
                                    // ),
                                    borderRadius: BorderRadius.circular(30.0),
                                    // border: Border(
                                    //   bottom:
                                    //       BorderSide(color: blue, width: 2),
                                    // )
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: black.withOpacity(0.1),
                                    //     blurRadius: 10,
                                    //   ),
                                    // ],
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
                        ],
                      ),
                    ),
                    Divider(),
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
            ),
          );
        });
  }

  showSwitchPlayer() {
    final tableProvider = Provider.of<MjProvider>(context, listen: false);
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
            tableProvider.cancelSwitchPlayer();
          },
        );
      },
    );
  }
}
