import 'package:flutter/material.dart';
import 'package:mahjong/resources/color.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  CustomBottomSheet({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 400.0),
      height: MediaQuery.of(context).size.width / 4 * 3 + 50,
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              height: 4,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.shade700,
              )),
          Expanded(child: child),
        ],
      ),
    );
  }
}
