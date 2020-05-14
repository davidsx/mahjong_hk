import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    loadDataAndPush();
  }

  loadDataAndPush() async {
    // DatabaseService.dbService.init().then((_) {
    SharedPreferences.getInstance().then((prefs) {
      final String tableID = prefs.getString('tableID') ?? "";
      final tableProvider = Provider.of<MJProvider>(context, listen: false);
      if (tableID.isNotEmpty) {
        tableProvider.initTableID(tableID);
        tableProvider.continueTable(tableID);
        // tableProvider.setTableID("");
      }
      Timer(
        Duration(milliseconds: 1000),
        () => Navigator.of(context).pushReplacementNamed(
          tableProvider.table.id.isEmpty ? '/rule' : '/home',
        ),
      );
    });
    // });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider icon = AssetImage("assets/icon_no_bg.png");
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xff82E8FF), Color(0xff82C3FF)],
        ),
      ),
      child: Center(
        child: Image(
          image: icon,
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
