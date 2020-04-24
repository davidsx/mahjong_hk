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
      body: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TableAppBar(),
              Expanded(child: TableRule()),
            ],
          ),
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
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClayContainer(
            height: 60,
            width: double.infinity,
            emboss: true,
            borderRadius: 10,
            color: Color(0xfff0f0f0),
            // curveType: CurveType.concave,
            child: Stack(
              children: <Widget>[
                AnimatedAlign(
                  duration: Duration(milliseconds: 500),
                  alignment: indexAlign,
                  child: FractionallySizedBox(
                      widthFactor: 1 / Globals().indexes.length,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClayContainer(
                          borderRadius: 10,
                        ),
                      )),
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
                                style: TextStyle(fontSize: 22)),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClayContainer(
            height: 60,
            width: double.infinity,
            emboss: true,
            borderRadius: 10,
            color: Color(0xfff0f0f0),
            // curveType: CurveType.concave,
            child: Stack(
              children: <Widget>[
                AnimatedAlign(
                  duration: Duration(milliseconds: 500),
                  alignment: amountAlign,
                  child: FractionallySizedBox(
                      widthFactor: 1 / Globals().amounts.length,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClayContainer(
                          borderRadius: 10,
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
                                style: TextStyle(fontSize: 22)),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 4.5,
              children: <Widget>[
                for (int i = 3; i < ruleset.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "$i番 :",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 40,
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                              // color: white,
                              border: Border.all(color: black.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "${ruleset[i]}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        Divider(),
        Form(
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  "邊個落場",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
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
                              // maxLength: 4,
                              autofocus: true,
                              onChanged: (text) =>
                                  playerNames[i * 2 + j] = text,
                              textInputAction: i * 2 + j >= 3
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                              cursorColor: green,
                              decoration: InputDecoration(
                                hintText: '${i * 2 + j + 1}',
                                hintStyle: TextStyle(fontSize: 16),
                                counterText: "",
                                border: InputBorder.none,
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
              height: 50,
              child: FlatButton(
                child: Text(
                  "開新牌局",
                  style: TextStyle(fontSize: 25.0, color: blueLight),
                ),
                onPressed: () {
                  var newList = playerNames.toSet().toList();
                  if (newList.length == playerNames.length) {
                    tableProvider.setTable(ruleIndex, ruleAmount, playerNames);
                    Navigator.of(context).pushReplacementNamed('/home');
                  }
                },
              )),
        )
      ],
    );
  }
}
