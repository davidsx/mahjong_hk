import 'dart:math';

import 'package:flutter/material.dart';

class NumberPicker extends StatefulWidget {
  @override
  _NumberPickerState createState() => _NumberPickerState();

  NumberPicker({this.itemWidth = 50.0});

  final double itemWidth;
  final double itemPadding = 10.0;
  final double itemHeight = 50.0;
}

class _NumberPickerState extends State<NumberPicker> {
  int ruleIndex = 0;
  double pos = 0;
  PageController pageController;
  ScrollController listController;
  @override
  void initState() {
    pageController = PageController(viewportFraction: 0.333, keepPage: false);
    listController = ScrollController()
      ..addListener(() {
        setState(() => pos = listController.offset / 50);
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (widget.itemWidth + widget.itemPadding * 2) +
          (widget.itemWidth * 1.1 + widget.itemPadding * 2) +
          (widget.itemWidth + widget.itemPadding * 2),
      height: widget.itemWidth,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
                width: (widget.itemWidth + widget.itemPadding * 2) +
                    (widget.itemWidth * 1.1 + widget.itemPadding * 2) +
                    (widget.itemWidth + widget.itemPadding * 2),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    // if (notification is ScrollUpdateNotification)
                    //   setState(() => pos = listController.offset);
                    return true;
                  },
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: listController,
                    itemCount: 8,
                    itemBuilder: (context, i) {
                      double scale =
                          (i - pos).abs() <= 1 ? 1 + 0.5 * (i - pos).abs() : 1;
                      return Container(
                        width: widget.itemWidth,
                        height: 50.0,
                        margin: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Center(
                          child: Transform.scale(
                            scale: scale,
                            child: Text(
                              '$i',
                              style: TextStyle(fontSize: 50.0),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                // child: NotificationListener<ScrollNotification>(
                //   onNotification: (notification) {
                //     // if (notification is ScrollUpdateNotification)
                //     setState(() => pos = pageController.page);
                //     return true;
                //   },
                //   child: PageView.builder(
                //     scrollDirection: Axis.horizontal,
                //     controller: pageController,
                //     onPageChanged: (pos) {
                //       print(pos);
                //       setState(() => ruleIndex = pos);
                //     },
                //     physics: BouncingScrollPhysics(),
                //     itemCount: 8,
                //     itemBuilder: (context, i) {
                //       double scale = (i - pos - 1).abs() <= 1
                //           ? 1 + 0.5 * (i - pos - 1).abs()
                //           : 1;
                //       return Container(
                //         width: widget.itemWidth,
                //         height: 50.0,
                //         margin: EdgeInsets.symmetric(horizontal: 15.0),
                //         child: Center(
                //           child: Transform.scale(
                //             scale: scale,
                //             child: Text(
                //               '$i',
                //               style: TextStyle(fontSize: 50.0),
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: widget.itemWidth * 2,
              child: Row(
                children: <Widget>[
                  Spacer(),
                  VerticalDivider(color: Colors.black, width: 4.0),
                  SizedBox(
                      width: widget.itemWidth * 1.1 + widget.itemPadding * 2),
                  VerticalDivider(color: Colors.black, width: 4.0),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
