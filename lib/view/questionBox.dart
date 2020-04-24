import 'package:flutter/material.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/resources/color.dart';

class QuestionBox extends StatelessWidget {
  final String title;
  final List<String> placeholder;
  final List<int> maxLength;
  final String yes;
  final String no;
  final Function(List<String>) action;
  final Function cancelAction;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final List<TextEditingController> controllers;

  QuestionBox({
    this.title = "",
    this.placeholder = const [""],
    this.maxLength = const [5],
    this.yes = "",
    this.no = "",
    @required this.action,
    this.cancelAction,
  }) : controllers = List<TextEditingController>.generate(
          placeholder.length,
          (i) => TextEditingController(),
        );

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
              height: 200.0,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (int i = 0; i < placeholder.length; i++)
                            TextFormField(
                              controller: controllers[i],
                              validator: (value) =>
                                  value.isEmpty ? '不可空白' : null,
                              // maxLength: maxLength[i],
                              autofocus: true,
                              // onChanged: (text) => value[i] = text,
                              textInputAction: TextInputAction.go,
                              cursorColor: green,
                              decoration: InputDecoration(
                                  hintText: placeholder[i], border: InputBorder.none),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: TextField(
                  //       // controller: controller,
                  //       autofocus: true,
                  //       onChanged: (text) => value = text,
                  //       textInputAction: TextInputAction.go,
                  //       cursorColor: green,
                  //       decoration: InputDecoration(
                  //           hintText: "香港人麻雀", border: InputBorder.none),
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //           fontSize: 20.0, fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                ],
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
                      cancelAction();
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
                    onTap: () {
                      if (_formkey.currentState.validate()) {
                        List<String> value =
                            controllers.map((c) => c.text).toList();
                        action(value);
                        Navigator.of(context).pop();
                      }
                    },
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
