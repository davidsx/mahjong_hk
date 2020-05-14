import 'package:flutter/material.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/resources/responsive.dart';

class CustomRaisedButton extends RaisedButton {
  CustomRaisedButton(BuildContext context, {onPressed, color, subcolor, text})
      : super(
          animationDuration: Duration(milliseconds: 100),
          elevation: 4,
          highlightElevation: 0,
          disabledElevation: 0,
          color: color,
          highlightColor: subcolor,
          disabledColor: subcolor,
          splashColor: transparent,
          textColor: black,
          disabledTextColor: grey,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveTheme(MediaQuery.of(context).size).headline1,
            vertical: ResponsiveTheme(MediaQuery.of(context).size).overline,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveTheme(MediaQuery.of(context).size).body1 +
                  ResponsiveTheme(MediaQuery.of(context).size).overline,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: ResponsiveTheme(MediaQuery.of(context).size).body1,
            ),
          ),
          onPressed: onPressed,
        );
}
