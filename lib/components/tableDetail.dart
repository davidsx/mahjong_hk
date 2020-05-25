import 'package:flutter/material.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/resources/responsive.dart';
import 'package:provider/provider.dart';

class TableDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double fontSize =
        ResponsiveTheme(MediaQuery.of(context).size).subtitle1;
    final tableProvider = Provider.of<MJProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: tableProvider.tmpWinner.isEmpty
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: Text("贏家",
                      style: TextStyle(
                        color: tableProvider.tmpWinner.isEmpty ? grey : black,
                      ))),
              if (tableProvider.tmpWinner.isNotEmpty)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (String t in tableProvider.winnerStr.trim().split(""))
                        SizedBox(
                            width: fontSize,
                            child: Center(
                              child: Text(
                                t.trim(),
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: fontSize, color: green),
                              ),
                            )),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Divider(thickness: 2.0),
        Expanded(
          flex: 2,
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: tableProvider.loserStr.isEmpty
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: Text("輸家",
                      style: TextStyle(
                        color: tableProvider.winnerStr.isEmpty ? grey : black,
                      ))),
              if (tableProvider.loserStr.isNotEmpty)
                Center(
                  child: FittedBox(
                    child: Column(
                      children: <Widget>[
                        for (String loser in tableProvider.loserStr)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (String t in loser.trim().split(""))
                                SizedBox(
                                    width: fontSize,
                                    child: Center(
                                      child: Text(
                                        t.trim(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: fontSize, color: red),
                                      ),
                                    ))
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Divider(thickness: 2.0),
        Expanded(
          flex: 2,
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: tableProvider.ruleStr.isEmpty &&
                          tableProvider.methodStr.isEmpty
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: Text("番數",
                      style: TextStyle(
                        color: tableProvider.winnerStr.isEmpty ? grey : black,
                      ))),
              if (tableProvider.ruleStr.isNotEmpty ||
                  tableProvider.methodStr.isNotEmpty)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (String t in (tableProvider.ruleStr +
                              " " +
                              tableProvider.methodStr)
                          .trim()
                          .split(""))
                        SizedBox(
                            width: fontSize,
                            child: Center(
                              child: Text(t.trim(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: fontSize)),
                            ))
                    ],
                  ),
                ),
            ],
          ),
        ),
        Divider(thickness: 2.0),
      ],
    );
  }
}
