import 'package:flutter/material.dart';

class TableAppBar extends StatelessWidget {
  TableAppBar({this.title = ""});
  final String title;
  @override
  Widget build(BuildContext context) {
    // final mjName = Provider.of<MjProvider>(context).getMjName;
    return SizedBox(
      height: 100,
      child: Center(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            Expanded(
              child: Center(
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0)),
              ),
            ),
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
