import 'package:flutter/material.dart';

class TransparentInkWell extends InkWell {
  TransparentInkWell({child, onTap, onLongPress})
      : super(
          child: child,
          onTap: onTap,
          onLongPress: onLongPress,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
        );
}