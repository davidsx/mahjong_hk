import 'package:flutter/material.dart';
import 'package:mahjong/components/playerBox.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/models/globals.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/resources/responsive.dart';
import 'package:mahjong/view/skeleton.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class TableBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<MJProvider>(context);
    final mediaSize = MediaQuery.of(context).size;
    final theme = ResponsiveTheme(mediaSize);

    return SizedBox.fromSize(
      size: Size.fromHeight(mediaSize.height * 45 / 100),
      child: Stack(
        children: <Widget>[
          // ! For Testing
          // Align(alignment: Alignment.topLeft, child: Text("-1.0")),
          // Align(alignment: Alignment.bottomRight, child: Text("1.0")),
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
          if (tableProvider.isSetting ||
              tableProvider.state == TableState.RearrageSeat)
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
          if (!tableProvider.isSwitching)
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
                  style: TextStyle(fontSize: theme.overline),
                ),
              ),
            ),
          // * SwitchPlayer Start
          if (tableProvider.isWaiting)
            Positioned(
              top: 10,
              left: 10,
              child: TransparentInkWell(
                child: Text(
                  "換人",
                  style: TextStyle(
                    color: blue,
                    decoration: TextDecoration.underline,
                    fontSize: theme.caption,
                  ),
                ),
                onTap: () {
                  tableProvider.switchPlayer();
                },
              ),
            ),
          // * Wind + Stage
          if (tableProvider.isLoading)
            Positioned(
              top: 10,
              right: 10,
              child: Skeleton(height: 30, width: 50, borderRadius: 15.0),
            )
          else if (tableProvider.isWaiting)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                height: theme.caption + 15,
                width: theme.caption * 3.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((theme.caption + 15) / 2),
                  color: black.withOpacity(0.7),
                ),
                child: Center(
                  child: Text(
                    Globals().getWindStageStr(tableProvider.table.stage),
                    style: TextStyle(
                      color: white,
                      fontSize: theme.caption,
                    ),
                  ),
                ),
              ),
            ),
          // * PlayerBox
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: <Widget>[
                  if (tableProvider.isWaiting ||
                      tableProvider.state == TableState.SettingReady)
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 6 / 7,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Transform.rotate(
                              angle:
                                  tableProvider.table.dealer * (-math.pi / 2),
                              child: CustomPaint(
                                size: Size.infinite,
                                painter: TableCirclePainter(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 1 / 3,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Image(
                            image: AssetImage("assets/icon_no_bg.png"),
                            width: 150,
                            height: 150,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TableCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.width / 2);
    Paint paint = Paint()
      ..color = greenLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, paint);

    double arrowOrigin = radius * (1 + math.pow(2, -0.5));
    canvas.drawLine(Offset(arrowOrigin, arrowOrigin),
        Offset(arrowOrigin - 12, arrowOrigin), paint);
    canvas.drawLine(Offset(arrowOrigin, arrowOrigin),
        Offset(arrowOrigin, arrowOrigin + 12), paint);
  }

  @override
  bool shouldRepaint(TableCirclePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TableCirclePainter oldDelegate) => false;
}
