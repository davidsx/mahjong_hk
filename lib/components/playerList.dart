import 'package:flutter/material.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/models/player.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:provider/provider.dart';

class PlayerList extends StatelessWidget {
  PlayerList(this.players);
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2, childAspectRatio: 1, shrinkWrap: true,
        // scrollDirection: Axis.horizontal,
        children: [for (var p in players) PlayerListItem(p)]);
  }
}

class PlayerListItem extends StatelessWidget {
  PlayerListItem(this.player);
  final Player player;

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<MJProvider>(context, listen: false);
    final bool active = tableProvider.table.playerNames.contains(player.name);
    // print(active);
    return Container(
      decoration: BoxDecoration(
          // border: Border(
          //   bottom: BorderSide(
          //     color: drawBottomDivider ? grey : transparent,
          //     width: 1,
          //   ),
          // ),
          ),
      child: TransparentInkWell(
        onTap: () {
          active
              ? tableProvider.setPlayer(player, false)
              : tableProvider.setPlayer(player, true);
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: active ? blueLight : transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: black.withOpacity(0.1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        player.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        "${player.balance}",
                        style: TextStyle(
                          color: player.balance == 0
                              ? grey
                              : player.balance > 0
                                  ? greenDark
                                  : player.balance < 0 ? redDark : black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // if (active && index >= 0)
            // Center(
            //   child: Text(
            //     "${index + 1}",
            //     style: TextStyle(
            //       color: blue.withOpacity(0.3),
            //       fontSize: 70,
            //     ),
            //   ),
            // ),
            // Positioned(
            //   top: 20,
            //   right: 20,
            //   child: Container(
            //     height: 30,
            //     width: 30,
            //     // decoration: BoxDecoration(
            //     //   border: Border.all(color: blueLight),
            //     //   borderRadius: BorderRadius.circular(3),
            //     // ),
            //     child: Center(
            //       child: Text(
            //         "${index + 1}",
            //         style: TextStyle(
            //           color: blue,
            //           fontSize: 20,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
