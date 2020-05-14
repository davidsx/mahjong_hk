import 'package:flutter/material.dart';

class TransparentInkWell extends InkWell {
  TransparentInkWell({child, onTap, onLongPress, onDoubleTap})
      : super(
          child: child,
          onTap: onTap,
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
        );
}