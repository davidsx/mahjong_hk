import 'package:flutter/material.dart';
import 'package:mahjong/resources/responsive.dart';

class TableAppBar extends AppBar {
  TableAppBar(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey, {
    String title = "",
  }) : super(
          backgroundColor: Color(0xfff0f0f0),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => scaffoldKey.currentState.openDrawer(),
          ),
          title: Text(
            title.isNotEmpty ? title : '香港人麻雀',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveTheme(MediaQuery.of(context).size).subtitle1,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {},
            ),
          ],
        );
}
