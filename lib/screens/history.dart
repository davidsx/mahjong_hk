import 'package:flutter/material.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/extensions/TableAppBar.dart';
import 'package:mahjong/models/globals.dart';
import 'package:mahjong/models/table.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/resources/responsive.dart';
import 'package:mahjong/view/tableDrawer.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<MJProvider>(context, listen: false);
    // final mjProvider = Provider.of<MjProvider>(context, listen: false);
    return Scaffold(
      key: Globals().historyScaffoldKey,
      appBar: TableAppBar(context, Globals().historyScaffoldKey),
      body: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: TableHistory()),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                    height: 50,
                    child: FlatButton(
                      child: Text(
                        "開新牌局",
                        style: TextStyle(fontSize: 25.0, color: blueLight),
                      ),
                      onPressed: () {
                        tableProvider.newTable();
                        // playerProvider.deactivateAllPllayer();
                        Navigator.of(context).pushReplacementNamed('/rule');
                      },
                    )),
              )
            ],
          ),
        ),
      ),
      drawer: TableDrawer(scaffoldContext: context),
    );
  }
}

class TableHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<MJProvider>(context);

    if (tableProvider.tableHistory.isEmpty) {
      return Center(
        child: Text('無記錄', style: TextStyle(fontSize: 20.0, color: grey)),
      );
    }
    return ListView(
      children: <Widget>[
        for (var t in tableProvider.tableHistory) TableHistoryItem(t),
      ],
    );
  }
}

class TableHistoryItem extends StatelessWidget {
  final TableModel table;
  TableHistoryItem(this.table);

  @override
  Widget build(BuildContext context) {
    final mjProvider = Provider.of<MJProvider>(context, listen: false);
    final theme = ResponsiveTheme(MediaQuery.of(context).size);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: TransparentInkWell(
        onTap: () {
          if (!table.gameEnd) {
            mjProvider.continueTable(table.id);
            mjProvider.setTableID(table.id);
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        child: Dismissible(
          key: new ValueKey(table.id),
          direction: DismissDirection.startToEnd,
          onDismissed: (_) {
            mjProvider.deleteTable(table);
          },
          background: Container(
            padding: EdgeInsets.all(10.0),
            color: red,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 65,
                width: 40,
                child: Center(
                  child: Icon(
                    Icons.delete,
                    color: white,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          ),
          child: SizedBox(
            height: theme.historyBox,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    for (var p in table.players)
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(p.name, style: TextStyle(fontSize: theme.subtitle1)),
                              Text(p.balance.toString(),
                                  style: TextStyle(
                                    fontSize: theme.subtitle2,
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
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "${table.lastUpdated.month}/${table.lastUpdated.day}/${table.lastUpdated.year}",
                              style: TextStyle(fontSize: theme.overline, color: grey),
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
                                          ? Globals()
                                              .getWindStageStr(table.stage)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
