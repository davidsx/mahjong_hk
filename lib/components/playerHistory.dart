import 'package:flutter/material.dart';
import 'package:mahjong/models/globals.dart';
import 'package:mahjong/models/round.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/resources/responsive.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

class PlayerHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<MJProvider>(context);
    final theme = ResponsiveTheme(MediaQuery.of(context).size);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView.builder(
        controller: ScrollController(
          initialScrollOffset: 50.0 * tableProvider.table.rounds.length,
        ),
        shrinkWrap: false,
        itemCount: tableProvider.table.history.length,
        itemBuilder: (context, i) {
          return StickyHeader(
            header: header(tableProvider.table.historyPlayers[i], theme),
            content: Column(
              children: <Widget>[
                if (tableProvider.table.history.isEmpty)
                  Container()
                else
                  for (Round r in tableProvider.table.history[i]) row(r, theme)
              ],
            ),
          );
        },
      ),
    );
  }

  header(List<String> players, ResponsiveTheme theme) {
    return Container(
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
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: theme.caption)),
          for (var p in players)
            Text(p,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: theme.body1, color: blue)),
          Text("",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: theme.caption)),
          // Text("")
        ].map((w) => Expanded(child: Center(child: w))).toList(),
      ),
    );
  }

  row(Round r, ResponsiveTheme theme) {
    Color captionColor = black;
    if (r.roundCaption == '冧莊')
      captionColor = grey.withOpacity(0.5);
    else if (r.roundCaption == '過莊') captionColor = grey.withOpacity(0.8);
    return Container(
      height: theme.headline2 * 2,
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
              Globals().getWindStageStr(r.roundStage),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: black,
                fontSize: theme.caption,
              ),
            ),
          ),
          if (r.isSwitchPlayer)
            ...[
              Text(
                r.loser.first,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: theme.caption),
              ),
              Center(child: Icon(Icons.arrow_forward)),
              Text(
                r.winner,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: theme.caption),
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
                      fontSize: theme.body1,
                      color: p == r.winner
                          ? green
                          : r.loser.contains(p) ? red : grey),
                ),
            ].map((w) => Expanded(flex: 3, child: w)).toList(),
          Expanded(
            flex: 3,
            child: Text(
              r.roundCaption,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: captionColor,
                fontSize: theme.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }

  playerName(name) => Text(name,
      textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: blue));

  winText(amount) => Text("$amount",
      textAlign: TextAlign.center, style: TextStyle(color: green));
  loseText(amount) => Text("-$amount",
      textAlign: TextAlign.center, style: TextStyle(color: red));
  emptyText() =>
      Text("-", textAlign: TextAlign.center, style: TextStyle(color: grey));
}
