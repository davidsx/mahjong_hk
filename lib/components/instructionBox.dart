import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart' show radians;

class InstructionBox extends StatelessWidget {
  final AnimationController controller;
  InstructionBox(this.controller)
      : scale = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
        );

  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<MJProvider>(context);
    
    return AnimatedBuilder(
        animation: controller,
        builder: (context, builder) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.scale(
                scale: scale.value - 1.0,
                child: FloatingActionButton(
                  child: Icon(Icons.cancel),
                  backgroundColor: greenLight,
                  onPressed: () {
                    controller.reverse();
                    tableProvider.endEventHandling();
                  },
                  elevation: 0,
                ),
              ),
              Transform.scale(
                scale: scale.value,
                child: TransparentInkWell(
                  onTap: () {
                    tableProvider.startEventHandling();
                    controller.forward();
                  },
                  child: Image(
                    image: AssetImage("assets/icon_no_bg.png"),
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
