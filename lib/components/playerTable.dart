import 'package:flutter/material.dart';
import 'package:mahjong/components/playerBox.dart';
import 'package:mahjong/components/playerInstuction.dart';
import 'package:mahjong/components/tableWindStage.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class TableBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<MjProvider>(context, listen: false);
    return Consumer<MjProvider>(
      builder: (context, value, child) {
        return AspectRatio(
          aspectRatio: 9 / 8,
          child: Stack(
            children: <Widget>[
              // Align(alignment: Alignment.topLeft, child: Text("-1.0")),
              // Align(alignment: Alignment.bottomRight, child: Text("1.0")),
              // ! For Testing
              // if (value.isWaiting)
              //   Positioned(
              //     top: 50,
              //     left: 10,
              //     child: TransparentInkWell(
              //       child: Text(
              //         "test",
              //         style: TextStyle(
              //           color: blue,
              //           decoration: TextDecoration.underline,
              //         ),
              //       ),
              //       onTap: () {
              //         tableProvider.gameEnd();
              //       },
              //     ),
              //   ),
              // * Ratate Seat
              if (value.isSetting || value.state == TableState.RearrageSeat)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: TransparentInkWell(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("轉位"),
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    onTap: () {
                      tableProvider.rotateSeat();
                    },
                  ),
                ),
              // * Ruleset
              if (!value.isSwitching)
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(),
                      // color: black.withOpacity(0.7),
                    ),
                    child: Text(
                      "${tableProvider.table.ruleIndex}番${tableProvider.table.ruleAmount}",
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ),
              // * SwitchPlayer Start
              if (value.isWaiting)
                Positioned(
                  top: 10,
                  left: 10,
                  child: TransparentInkWell(
                    child: Text(
                      "換人",
                      style: TextStyle(
                        color: blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      tableProvider.switchPlayer();
                    },
                  ),
                )
              // * SwitchPlayer Cancel
              else if (value.isSwitching)
                Positioned(
                  top: 10,
                  left: 10,
                  child: TransparentInkWell(
                    child: Text(
                      "取消",
                      style: TextStyle(
                        color: blue.withOpacity(0.7),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      tableProvider.cancelSwitchPlayer();
                    },
                  ),
                ),
              // * Wind + Stage
              Positioned(
                top: 10,
                right: 10,
                child: TableWindStage(),
              ),
              // * PlayerBox
              for (int i in [0, 1, 2, 3])
                AnimatedAlign(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  alignment: Alignment(
                    i % 2 == 0 ? 0.0 : (2.0 - i), // ? x
                    i % 2 == 1 ? 0.0 : (1.0 - i), // ? y
                  ),
                  child: TablePlayerBox(i),
                ),
              // * InstructionBox
              Center(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                  ),
                  child: TableInstructionBox(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
