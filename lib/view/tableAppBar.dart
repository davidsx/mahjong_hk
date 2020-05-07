import 'package:flutter/material.dart';

class TableAppBar extends StatelessWidget implements PreferredSizeWidget {
  TableAppBar({this.title = ""}) : preferredSize = Size.fromHeight(60);

  @override
  final Size preferredSize;
  final String title;
  @override
  Widget build(BuildContext context) {
    final mjName = '香港人麻雀';
    return AppBar(
      backgroundColor: Color(0xfff0f0f0),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: Text(
        title.isNotEmpty ? title : mjName,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {},
        ),
      ],
    );
  }
}
