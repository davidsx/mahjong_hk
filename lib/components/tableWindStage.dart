import 'package:flutter/material.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/view/skeleton.dart';
import 'package:provider/provider.dart';

class TableWindStage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MjProvider>(
      builder: (context, value, child) {
        if (value.isLoading)
          return Skeleton(height: 30, width: 50, borderRadius: 15.0);
        else if (value.isWaiting)
          return Container(
            height: 30,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: black.withOpacity(0.7),
            ),
            child: Center(
              child: Text(
                value.table.currentWindStage,
                style: TextStyle(color: white, fontSize: 16),
              ),
            ),
          );
        else
          return Container();
      },
    );
  }
}
