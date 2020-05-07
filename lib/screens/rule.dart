import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/models/globals.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/view/tableAppBar.dart';
import 'package:mahjong/view/tableDrawer.dart';
import 'package:provider/provider.dart';

class RuleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      //resizeToAvoidBottomInset: false,
      appBar: TableAppBar(),
      body: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(child: TableRule()),
        ),
      ),
      drawer: TableDrawer(scaffoldContext: context),
    );
  }
}

class TableRule extends StatefulWidget {
  @override
  _TableRuleState createState() => _TableRuleState();
}

class _TableRuleState extends State<TableRule> {
  Alignment indexAlign, amountAlign;
  int ruleIndex, ruleAmount;
  static Globals g = Globals();
  static List<int> indexes = Globals().indexes;
  static List<int> amounts = Globals().amounts;

  List<TextEditingController> controllers =
      List<TextEditingController>.filled(4, TextEditingController());
  List<String> playerNames = List<String>.filled(4, "");

  setIndex(i) {
    ruleIndex = indexes[i];
    indexAlign = Alignment(-1 + i * 2 / (indexes.length - 1), 0);
  }

  setAmount(i) {
    ruleAmount = amounts[i];
    amountAlign = Alignment(-1 + i * 2 / (amounts.length - 1), 0);
  }

  List<int> get ruleset => Globals().getRuleSet(ruleIndex, ruleAmount);
  List<FocusNode> focusNodes =
      new List<FocusNode>.generate(4, (i) => new FocusNode());

  @override
  void initState() {
    super.initState();
    ruleIndex = 10;
    ruleAmount = 128;
    indexAlign = Alignment(
        -1 + indexes.indexOf(ruleIndex) * 2 / (indexes.length - 1), 0);
    amountAlign = Alignment(
        -1 + amounts.indexOf(ruleAmount) * 2 / (amounts.length - 1), 0);
  }

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<MjProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus && focusNodes.contains(currentFocus.focusedChild)) {
          currentFocus.unfocus();
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffe6e6e6),
            ),
            // curveType: CurveType.concave,
            child: Stack(
              children: <Widget>[
                AnimatedAlign(
                  duration: Duration(milliseconds: 200),
                  alignment: indexAlign,
                  child: FractionallySizedBox(
                    widthFactor: 1 / Globals().indexes.length,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xfff0f0f0),
                            boxShadow: [
                              BoxShadow(
                                color: black.withOpacity(0.4),
                                blurRadius: 10.0,
                                spreadRadius: 1.0,
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    for (int i = 0; i < Globals().indexes.length; i++)
                      Expanded(
                        child: TransparentInkWell(
                          onTap: () {
                            setState(() => setIndex(i));
                          },
                          child: Center(
                            child: Text("${indexes[i]}番",
                                style: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffe6e6e6),
            ),
            child: Stack(
              children: <Widget>[
                AnimatedAlign(
                  duration: Duration(milliseconds: 200),
                  alignment: amountAlign,
                  child: FractionallySizedBox(
                      widthFactor: 1 / Globals().amounts.length,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xfff0f0f0),
                              boxShadow: [
                                BoxShadow(
                                  color: black.withOpacity(0.4),
                                  blurRadius: 10.0,
                                  spreadRadius: 1.0,
                                ),
                              ]),
                        ),
                      )),
                ),
                Row(
                  children: <Widget>[
                    for (int i = 0; i < Globals().amounts.length; i++)
                      Expanded(
                        child: TransparentInkWell(
                          onTap: () {
                            setState(() => setAmount(i));
                          },
                          child: Center(
                            child: Text("${Globals().amounts[i]}",
                                style: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              children: <Widget>[
                for (int i = 3; i < ruleset.length; i++)
                  FractionallySizedBox(
                    widthFactor: 1 / 2,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "$i番 :",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 30,
                              margin: EdgeInsets.symmetric(horizontal: 15.0),
                              decoration: BoxDecoration(
                                // color: white,
                                border:
                                    Border.all(color: black.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "${ruleset[i]}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: GridView.count(
          //       crossAxisCount: 2,
          //       childAspectRatio: 5.5,
          //       children: <Widget>[
          //         for (int i = 3; i < ruleset.length; i++)
          //           Padding(
          //             padding: const EdgeInsets.only(bottom: 6.0),
          //             child: Row(
          //               children: <Widget>[
          //                 Expanded(
          //                   child: Text(
          //                     "$i番 :",
          //                     textAlign: TextAlign.center,
          //                     style: TextStyle(fontSize: 18),
          //                   ),
          //                 ),
          //                 Expanded(
          //                   child: Container(
          //                     height: 30,
          //                     margin: EdgeInsets.symmetric(horizontal: 15.0),
          //                     decoration: BoxDecoration(
          //                       // color: white,
          //                       border: Border.all(color: black.withOpacity(0.3)),
          //                       borderRadius: BorderRadius.circular(5),
          //                     ),
          //                     child: Center(
          //                       child: Text(
          //                         "${ruleset[i]}",
          //                         textAlign: TextAlign.center,
          //                         style: TextStyle(fontSize: 14),
          //                       ),
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //       ],
          //     ),
          //   ),
          // ),
          Divider(),
          Column(
            children: <Widget>[
              Center(
                child: Text(
                  "邊個落場",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              for (int i = 0; i < 2; i++)
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      for (int j = 0; j < 2; j++)
                        Container(
                          height: 50,
                          width: 100,
                          margin: EdgeInsets.symmetric(horizontal: 15.0),
                          decoration: BoxDecoration(
                            // color: white,
                            border: Border.all(color: black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: TextFormField(
                              // controller: controllers[i * 2 + j],
                              validator: (value) =>
                                  value.isEmpty ? '不可空白' : null,
                              // maxLength: 4,nn
                              onChanged: (text) =>
                                  playerNames[i * 2 + j] = text,
                              onFieldSubmitted: (String value) {
                                if (i * 2 + j <= 2)
                                  FocusScope.of(context).requestFocus(
                                      focusNodes[i * 2 + j + 1]);
                              },
                              textInputAction: i * 2 + j >= 3
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                              focusNode: focusNodes[i * 2 + j],
                              cursorColor: green,
                              decoration: InputDecoration(
                                hintText: '${i * 2 + j + 1}',
                                hintStyle: TextStyle(fontSize: 16),
                                counterText: "",
                                border: InputBorder.none,
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
                height: 30,
                child: FlatButton(
                  child: Text(
                    "開新牌局",
                    style: TextStyle(fontSize: 25.0, color: blueLight),
                  ),
                  onPressed: () {
                    var newList = playerNames.toSet().toList();
                    if (newList.length == playerNames.length) {
                      tableProvider.setTable(
                          ruleIndex, ruleAmount, playerNames);
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  },
                )),
          )
        ],
      ),
    );
  }
}
