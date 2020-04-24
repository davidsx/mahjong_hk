import 'package:flutter/material.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:provider/provider.dart';

class TableDetail extends StatelessWidget {
  final double playerFontSize = 30.0;
  final double ruleMethodFontSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<MjProvider>(
      builder: (context, value, child) {
        if (value.isWaiting)
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
                        alignment: value.tmpWinner.isEmpty
                            ? Alignment.center
                            : Alignment.centerLeft,
                        child: Text("贏家",
                            style: TextStyle(
                              color: value.tmpWinner.isEmpty ? grey : black,
                            ))),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (String t in value.winner.trim().split(""))
                            SizedBox(
                                width: playerFontSize,
                                child: Center(
                                  child: Text(
                                    t.trim(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: playerFontSize,
                                        color: green),
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
                        alignment: value.loser.isEmpty
                            ? Alignment.center
                            : Alignment.centerLeft,
                        child: Text("輸家",
                            style: TextStyle(
                              color: value.winner.isEmpty ? grey : black,
                            ))),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (String t
                              in value.loser.join(" ").trim().split(""))
                            SizedBox(
                                width: playerFontSize,
                                child: Center(
                                  child: Text(
                                    t.trim(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: playerFontSize, color: red),
                                  ),
                                ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 2.0),
              Expanded(
                flex: 3,
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: value.rule.isEmpty && value.method.isEmpty
                            ? Alignment.center
                            : Alignment.centerLeft,
                        child: Text("番數",
                            style: TextStyle(
                              color: value.winner.isEmpty ? grey : black,
                            ))),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (String t in (value.rule + " " + value.method)
                              .trim()
                              .split(""))
                            SizedBox(
                                width: ruleMethodFontSize,
                                child: Center(
                                  child: Text(t.trim(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: ruleMethodFontSize)),
                                ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 2.0),
              // Expanded(flex: 1, child: FlatButton(
              //   child: Text(""),
              // ))
            ],
          );
        else
          return Container();
      },
    );
  }
}
