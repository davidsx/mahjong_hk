import 'package:flutter/material.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/screens/history.dart';
import 'package:mahjong/screens/home.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/screens/rule.dart';
import 'package:mahjong/screens/splash.dart';
import 'package:mahjong/view/numberPicker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    precacheImage(AssetImage("assets/icon_no_bg.png"), context);
    return BlocWrapper(
      child: OverlaySupport(
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: white,
            scaffoldBackgroundColor: backgroundColor,
            dialogBackgroundColor: backgroundColor,
          ),
          home: SplashScreen(),
          routes: {
            '/home': (_) => HomeScreen(),
            '/history': (_) => HistoryScreen(),
            '/rule': (_) => RuleScreen(),
          },
        ),
      ),
    );
  }
}

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          // width: 500,
          // height: ((ruleset.length / 3).ceil() * 60).toDouble(),
          height: 240 + 30.0,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: NumberPicker(),
        ),
      ),
    );
  }
}

class BlocWrapper extends StatelessWidget {
  final Widget child;
  BlocWrapper({@required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider<PlayerProvider>(create: (_) => PlayerProvider()),
        ChangeNotifierProvider<MJProvider>(create: (context) => MJProvider())
      ],
      child: child,
    );
  }
}
