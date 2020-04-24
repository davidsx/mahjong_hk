import 'package:flutter/material.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/view/alertBox.dart';
import 'package:provider/provider.dart';

class TableDrawer extends StatelessWidget {
  // final BuildContext homeCtx = Globals().homeKey.currentContext;
  final BuildContext scaffoldContext;
  TableDrawer({this.scaffoldContext});

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<MjProvider>(scaffoldContext);
    // if (tableProvider.table.id.isNotEmpty)
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.25,
      child: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: Text(
                    '香港人麻雀',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text('v1.0 Beta'),
                ),
                ListTile(
                  title: Text('查看歷史', style: TextStyle(fontSize: 20)),
                  onTap: () {
                    tableProvider.loadHistory();
                    Navigator.of(context).pushReplacementNamed('/history');
                  },
                ),
                Divider(),
                ListTile(
                  enabled: tableProvider.isWaiting &&
                      tableProvider.table.rounds.length > 0,
                  title: Text('刪除上局',
                      style: TextStyle(
                        fontSize: 20,
                        color: tableProvider.isWaiting &&
                                tableProvider.table.rounds.length > 0
                            ? black
                            : grey,
                      )),
                  onTap: () {
                    if (tableProvider.isWaiting) {
                      bool lastRoundSwitched =
                          tableProvider.table.rounds.last.isSwitchPlayer;
                      Navigator.pop(context);
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
                            },
                          );
                        },
                      );
                    }
                  },
                ),
                ListTile(
                  enabled: tableProvider.isWaiting &&
                      tableProvider.table.rounds.length > 0,
                  title: Text('重新開始',
                      style: TextStyle(
                        fontSize: 20,
                        color: tableProvider.isWaiting &&
                                tableProvider.table.rounds.length > 0
                            ? black
                            : grey,
                      )),
                  onTap: () {
                    if (tableProvider.isWaiting) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertBox(
                            title: "重新開始？",
                            subtitle: tableProvider.table.isPlayerSwitched
                                ? "(以換人後的玩家重開新局)"
                                : "",
                            yes: '係呀',
                            no: '唔係',
                            action: () {
                              tableProvider.restartTable();
                              Navigator.pop(dialogContext);
                            },
                          );
                        },
                      );
                    }
                  },
                ),
                Divider(),
                ListTile(
                  enabled: !tableProvider.isSetting,
                  title: Text('開新牌局',
                      style: TextStyle(
                        fontSize: 20,
                        color: tableProvider.isSetting ? grey : black,
                      )),
                  onTap: () {
                    if (!tableProvider.isSetting) {
                      Navigator.pop(context);
                      if (tableProvider.isLoading) {
                        tableProvider.newTable();
                        Navigator.of(context).pushReplacementNamed('/rule');
                      } else
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
                                Navigator.of(dialogContext)
                                    .pushReplacementNamed('/rule');
                              },
                            );
                          },
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // else
    //   return SizedBox(
    //     width: MediaQuery.of(context).size.width / 1.15,
    //     child: Drawer(
    //       child: SafeArea(
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
    //           child: Column(
    //             // padding: EdgeInsets.zero,
    //             children: <Widget>[
    //               ListTile(
    //                 title: Text(
    //                   '香港人麻雀',
    //                   style: TextStyle(
    //                     fontSize: 24,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 trailing: Text('v1.0 Beta'),
    //               ),
    //               Divider(),
    //               Expanded(
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(10.0),
    //                   child: Container(
    //                     padding: const EdgeInsets.all(30.0),
    //                     decoration: BoxDecoration(
    //                       color: grey.withOpacity(0.2),
    //                       borderRadius: BorderRadius.circular(10.0),
    //                     ),
    //                     child: Text(
    //                       '請先加入任何現有雀局。\n\n玩家可以通過輸入由其他雀局玩家提供的雀局ID加入雀局。\n\n你亦可建立新雀局並發送雀局ID邀請其他玩家加入。',
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         height: 1.75,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
  }
}
