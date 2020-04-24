import 'package:flutter/material.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/resources/color.dart';

class AlertBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final String yes;
  final String no;
  final VoidCallback action;

  AlertBox({
    this.title = "",
    this.subtitle = "",
    this.yes = "",
    this.no = "",
    @required this.action,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 150.0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28.0),
                    ),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TransparentInkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: greenLight,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                        ),
                      ),
                      child: Text(
                        no,
                        style: TextStyle(color: white, fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Expanded(
                  child: TransparentInkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(32.0),
                        ),
                      ),
                      child: Text(
                        yes,
                        style: TextStyle(color: white, fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: action,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
