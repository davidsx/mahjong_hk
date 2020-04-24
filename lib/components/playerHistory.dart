import 'package:flutter/material.dart';
import 'package:mahjong/models/round.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

class PlayerHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MjProvider>(
      builder: (context, value, child) {
        return Container(
            // padding: const EdgeInsets.all(20),
            // margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // color: blue.withOpacity(0.3),
            ),
            child: ListView.builder(
              controller: ScrollController(
                initialScrollOffset: 50.0 * value.table.rounds.length,
              ),
              shrinkWrap: true,
              itemCount: value.table.history.length,
              itemBuilder: (context, i) {
                return StickyHeader(
                  header: header(value.table.historyPlayers[i]),
                  content: Column(
                    children: <Widget>[
                      if (value.table.history.isEmpty)
                        Container()
                      else
                        for (Round r in value.table.history[i]) row(r)
                    ],
                  ),
                );
              },
            )
            // child: Column(
            //   children: <Widget>[
            //     header(value.table.playerNames),
            //     Divider(),
            //     if (value.table.rounds.length > 0)
            //       Expanded(
            //         child: ListView(
            //           controller: ScrollController(
            //               initialScrollOffset: 50.0 * value.table.rounds.length),
            //           shrinkWrap: true,
            //           children: <Widget>[
            //             for (var r in value.table.rounds) row(r),
            //           ],
            //         ),
            //       ),
            //   ],
            // ),
            );
        // return Container();
      },
    );
  }

  header(List<String> players) => Container(
        height: 50.0,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: grey.withOpacity(0.7)),
          ),
          color: backgroundColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("局數",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            for (var p in players)
              Text(p,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: blue)),
            // Text("")
          ].map((w) => Expanded(child: w)).toList(),
        ),
      );

  row(Round r) => Container(
        height: 50.0,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: grey.withOpacity(0.2)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(
                r.caption,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: r.isNormal || r.isSwitchPlayer
                      ? black
                      : grey.withOpacity(r.isChangeDealer ? 0.8 : 0.3),
                ),
              ),
            ),
            if (r.isSwitchPlayer)
              ...[
                Text(
                  r.loser.first,
                  textAlign: TextAlign.center,
                ),
                Center(child: Icon(Icons.arrow_forward)),
                Text(
                  r.winner,
                  textAlign: TextAlign.center,
                )
              ].map((w) => Expanded(flex: 4, child: w)).toList()
            else
              ...[
                for (var p in r.players)
                  Text(
                    p == r.winner
                        ? "${r.winningAmount}"
                        : r.loser.contains(p) ? "${r.losingAmount}" : "-",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: p == r.winner
                            ? green
                            : r.loser.contains(p) ? red : grey),
                  ),
              ].map((w) => Expanded(flex: 3, child: w)).toList()
            // Text(r.expression),
          ],
        ),
      );

  playerName(name) => Text(name,
      textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: blue));

  winText(amount) => Text("$amount",
      textAlign: TextAlign.center, style: TextStyle(color: green));
  loseText(amount) => Text("-$amount",
      textAlign: TextAlign.center, style: TextStyle(color: red));
  emptyText() =>
      Text("-", textAlign: TextAlign.center, style: TextStyle(color: grey));
}
