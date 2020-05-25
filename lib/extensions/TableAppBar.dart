import 'package:flutter/material.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:provider/provider.dart';

class TableAppBar extends StatefulWidget implements PreferredSizeWidget {
  TableAppBar({this.title = ""}) : appBar = new AppBar();

  final String title;
  final AppBar appBar;

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  @override
  _TableAppBarState createState() => _TableAppBarState();
}

class _TableAppBarState extends State<TableAppBar> {
  OverlayEntry _overlayEntry;

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<MJProvider>(context, listen: false);

    return AppBar(
      backgroundColor: Color(0xfff0f0f0),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          tableProvider.loadHistory();
          // Navigator.of(context).pushReplacementNamed('/history');
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Text(
        widget.title.isNotEmpty ? widget.title : '香港人麻雀',
        textAlign: TextAlign.center,
        style: TextStyle(
          // fontSize: ResponsiveTheme(MediaQuery.of(context).size).subtitle1,
          fontSize: 25,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            this._overlayEntry = _createOverlayEntry();
            Overlay.of(context).insert(this._overlayEntry);
          },
        ),
      ],
    );
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Container(
        width: double.infinity - 100,
        height: double.infinity - 100,
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.8),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      tutorialText,
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.1,
                        color: white,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.6),
                  child: TransparentInkWell(
                    child: Icon(Icons.clear, color: white),
                    onTap: () {
                      this._overlayEntry.remove();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get tutorialText => '''
1.出銃
      先輕按贏家，再輕按輸家，選好番數後按確定。

2.自摸
      先長按贏家，選好番數後按確定。

3.包自摸
      先輕按贏家，再長按輸家，選好番數後按確定。

4.查看歷史
      輕按左上角欄目即可查閱歷史。''';
}
