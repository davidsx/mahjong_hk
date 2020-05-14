import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahjong/components/BottomArea.dart';
import 'package:mahjong/components/playerTable.dart';
import 'package:mahjong/extensions/TableAppBar.dart';
import 'package:mahjong/models/globals.dart';
import 'package:mahjong/view/tableDrawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Globals().homeScaffoldKey,
      appBar: TableAppBar(context, Globals().homeScaffoldKey),
      body: Stack(
        children: <Widget>[
          // if (!value.isLoading)
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TableBox(),
                  Expanded(flex: 3, child: BottomArea()),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: TableDrawer(scaffoldContext: context),
    );
  }
}