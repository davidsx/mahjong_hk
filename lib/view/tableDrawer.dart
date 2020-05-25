import 'package:flutter/material.dart';
import 'package:mahjong/components/playerHistory.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/models/globals.dart';
import 'package:mahjong/models/table.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/resources/responsive.dart';
import 'package:mahjong/screens/history.dart';
import 'package:mahjong/view/alertBox.dart';
import 'package:provider/provider.dart';

class TableDrawer extends StatelessWidget {
  // final BuildContext homeCtx = Globals().homeKey.currentContext;
  final BuildContext scaffoldContext;
  TableDrawer({this.scaffoldContext});

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<MJProvider>(scaffoldContext);
    // if (tableProvider.table.id.isNotEmpty)
    print(tableProvider.tableHistory.length);
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: tableProvider.tableHistory.isEmpty
                ? Center(
                    child: Text('無記錄',
                        style: TextStyle(fontSize: 20.0, color: grey)),
                  )
                : ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "歷史牌局",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Divider(),
                      for (var t in tableProvider.tableHistory)
                        historyListTile(t),
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

  historyListTile(TableModel table) {
    final tableProvider = Provider.of<MJProvider>(scaffoldContext);
    final theme = ResponsiveTheme(MediaQuery.of(scaffoldContext).size);
    return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: TransparentInkWell(
        onTap: () {
          if (!table.gameEnd) {
            tableProvider.continueTable(table.id);
            tableProvider.setTableID(table.id);
            Navigator.of(scaffoldContext).pushReplacementNamed('/home');
          }
        },
        child: SizedBox(
          // height: theme.historyBox,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  for (var p in table.players)
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FittedBox(
                              child: Text(p.name,
                                  style: TextStyle(fontSize: theme.subtitle2)),
                            ),
                            Text(p.balance.toString(),
                                style: TextStyle(
                                  fontSize: theme.body1,
                                  color: p.balance == 0
                                      ? grey
                                      : p.balance > 0
                                          ? greenDark
                                          : p.balance < 0 ? redDark : black,
                                )),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "${table.lastUpdated.month}/${table.lastUpdated.day}/${table.lastUpdated.year}",
                            style: TextStyle(
                                fontSize: theme.overline, color: grey),
                          ),
                          if (table.gameEnd)
                            Text(
                              "完結",
                              style: TextStyle(
                                  fontSize: theme.body2,
                                  color: black.withOpacity(0.6)),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    (table.rounds ?? []).isNotEmpty
                                        ? Globals().getWindStageStr(table.stage)
                                        : "東1",
                                    style: TextStyle(
                                        fontSize: theme.caption,
                                        color: black.withOpacity(0.6)),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: 18),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: <Widget>[
              //     Text(
              //       "${table.lastUpdated.month}/${table.lastUpdated.day}/${table.lastUpdated.year}",
              //       style: TextStyle(fontSize: theme.overline, color: grey),
              //     ),
              //     if (table.gameEnd)
              //       Text(
              //         "完結",
              //         style: TextStyle(
              //             fontSize: theme.body2, color: black.withOpacity(0.6)),
              //       )
              //     else
              //       Padding(
              //         padding: const EdgeInsets.all(5.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             Text(
              //               (table.rounds ?? []).isNotEmpty
              //                   ? Globals().getWindStageStr(table.stage)
              //                   : "東1",
              //               style: TextStyle(
              //                   fontSize: theme.caption,
              //                   color: black.withOpacity(0.6)),
              //             ),
              //             Icon(Icons.arrow_forward_ios, size: 18),
              //           ],
              //         ),
              //       ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
