import 'package:flutter/material.dart';
import 'package:mahjong/extensions/TransparentInkWell.dart';
import 'package:mahjong/provider/mj_provider.dart';
import 'package:mahjong/resources/color.dart';
import 'package:mahjong/view/alertBox.dart';
import 'package:mahjong/view/skeleton.dart';
import 'package:provider/provider.dart';

class TableInstructionBox extends StatefulWidget {
  @override
  _TableInstructionBoxState createState() => _TableInstructionBoxState();
}

class _TableInstructionBoxState extends State<TableInstructionBox> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MjProvider>(
      builder: (context, value, child) {
        final Instruction instruction = Instruction.of(context);

        return FractionallySizedBox(
          widthFactor: 1 / 3,
          child: IgnorePointer(
            ignoring: instruction.callback == null,
            child: TransparentInkWell(
              onTap: instruction.callback,
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Card(
                  child: Center(
                    child: value.isLoading
                        ? Skeleton(
                            height: 20,
                            width: 40,
                          )
                        : instruction.text,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Instruction {
  final VoidCallback callback;
  final Widget text;

  Instruction(this.text, this.callback);

  factory Instruction.of(BuildContext context) {
    final MjProvider tableProvider = Provider.of<MjProvider>(context);
    final TableState state = tableProvider.state;
    Widget text;
    VoidCallback callback;

    // * For Text Widget
    double fontSize = 18;
    FontWeight fontWeight = FontWeight.normal;
    Color color = black;
    String innerText = "";

    if (state == TableState.SettingStarter) {
      innerText = "起莊";
      callback = null;
    } else if (state == TableState.SettingReady) {
      fontSize = 24;
      fontWeight = FontWeight.bold;
      color = green;
      innerText = "開枱!";
      callback = () => tableProvider.startGame();
      // callback = () => BlocProvider.of<TableBloc>(context).add(WaitingWinner());
    } else if (state == TableState.WaitingWinner) {
      innerText = "流局";
      callback = () => showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertBox(
                title: "無人食糊？",
                yes: '係呀',
                no: '唔係',
                action: () {
                  tableProvider.emptyRound();
                  Navigator.pop(dialogContext);
                },
              );
            },
          );
    } else if (state == TableState.WaitingLoser ||
        state == TableState.WaitingRuleset) {
      innerText = "取消";
      callback = () => tableProvider.cancelRound();
      // callback = () => BlocProvider.of<TableBloc>(context).add(CancelRound());
    } else if (state == TableState.WaitingConfirm) {
      innerText = "確定";
      callback = () => tableProvider.roundConfirm();
    } else if (state == TableState.SwitchingPlayerLeave ||
        state == TableState.SwitchingPlayerAdd) {
      innerText = "確定";
      color = grey.withOpacity(0.5);
      callback = null;
    } else if (state == TableState.SwitchingPlayerConfirm) {
      innerText = "確定";
      color = black;
      callback = () => tableProvider.confirmSwitchPlayer();
    } else if (state == TableState.GameEnd) {
      innerText = "執位";
      callback = () => tableProvider.rearrangeSeat();
    } else if (state == TableState.RearrageSeat) {
      innerText = "確定";
      if (tableProvider.table.isPlayerReady) {
        color = black;
        callback = () => tableProvider.confirmSeat();
      } else {
        color = grey.withOpacity(0.5);
        callback = null;
        
      }
    }
    text = Text(
      innerText,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
    return Instruction(text, callback);
  }
}
