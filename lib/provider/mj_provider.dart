import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mahjong/models/globals.dart';
import 'package:mahjong/models/method.dart';
import 'package:mahjong/models/player.dart';
import 'package:mahjong/models/round.dart';
import 'package:mahjong/models/table.dart';
import 'package:mahjong/service/db_sql.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TableState {
  LoadingTable,
  LoadingHistory,
  LoadingMj,
  SettingTable,
  SettingStarter,
  SettingReady,
  WaitingWinner,
  WaitingLoser,
  WaitingRuleset,
  WaitingConfirm,
  SwitchingPlayerLeave,
  SwitchingPlayerAdd,
  SwitchingPlayerConfirm,
  GameEnd,
  RearrageSeat
}

class MjProvider extends ChangeNotifier {
  final DatabaseService service = DatabaseService.dbService;
  final String tableRoute = 'MJtable';
  final String roundRoute = 'MJround';

  // * History
  String _tableID = "";
  String get getTableID => _tableID;
  Function(String) get initTableID => (str) {
        _tableID = str;
        // Globals().tableID = str;
      };
  Function(String) get setTableID => (str) {
        _tableID = str;
        // Globals().tableID = str;
        SharedPreferences.getInstance()
            .then((prefs) => prefs.setString('tableID', str));
      };
  List<TableModel> tableHistory = [];

  // * Basic
  TableModel table = TableModel.init();
  TableState state = TableState.SettingTable;

  // * Round
  String tmpWinner = "";
  List<String> tmpLoser = const [];
  int tmpRule = 0;
  Method tmpMethod = Method.Waiting;

  // * SwitchPlayer
  String tmpPlayerToLeave = "";
  String tmpPlayerToAdd = "";

  // bool get playersReady => table.activeCount >= 4;
  bool get isSetting =>
      state == TableState.SettingTable ||
      // state == TableState.SettingSeat ||
      state == TableState.SettingStarter ||
      state == TableState.SettingReady;
  bool get isWaiting =>
      state == TableState.WaitingWinner ||
      state == TableState.WaitingLoser ||
      state == TableState.WaitingRuleset ||
      state == TableState.WaitingConfirm;
  bool get isLoading =>
      state == TableState.LoadingTable ||
      state == TableState.LoadingHistory ||
      state == TableState.LoadingMj;
  bool get isSwitching =>
      state == TableState.SwitchingPlayerLeave ||
      state == TableState.SwitchingPlayerAdd ||
      state == TableState.SwitchingPlayerConfirm;

  Round get round => Round.newRound(tmpWinner, tmpLoser, tmpMethod, tmpRule,
      table.id, table.playerNames, table.ruleIndex, table.ruleAmount);

  String get method => tmpMethod == Method.SimpleWin
      ? "出銃"
      : tmpMethod == Method.SelfDraw
          ? "自摸"
          : tmpMethod == Method.SelfDrawByOne ? "包自摸" : "";

  String get rule => tmpRule >= 3 ? tmpRule.toString() + "番" : "";

  String get winner => tmpWinner;
  List<String> get loser => tmpLoser;

  _clearRound() {
    tmpWinner = "";
    tmpLoser = const [];
    tmpRule = 0;
    tmpMethod = Method.Waiting;
  }

  setTable(index, amount, playerNames) {
    table.setPlayer(playerNames);
    table.setRule(index, amount);
    state = TableState.SettingStarter;
    notifyListeners();
  }

  rotateSeat() {
    table.rotateSeat();
    notifyListeners();
  }

  setStarter(String starter) {
    table.setStarter(starter);
    state = TableState.SettingReady;
    notifyListeners();
  }

  startGame() {
    state = TableState.WaitingWinner;
    table.startGame();
    notifyListeners();
    // db.newTable(table);
    service.insert(tableRoute, table);
    setTableID(table.id);
  }

  winnerFound(String winner, [bool isSelfDraw = false]) {
    tmpWinner = winner;
    state = TableState.WaitingLoser;
    if (isSelfDraw) {
      tmpLoser = table.players
          .where((p) => p.name != winner)
          .map((p) => p.name)
          .toList();
      tmpMethod = Method.SelfDraw;
      state = TableState.WaitingRuleset;
    }
    notifyListeners();
  }

  loserFound(String loser, [bool isSelfDrawByOne = false]) {
    tmpLoser = [loser];
    tmpMethod = isSelfDrawByOne ? Method.SelfDrawByOne : Method.SimpleWin;
    state = TableState.WaitingRuleset;
    notifyListeners();
  }

  ruleSetFound(int ruleIndex) {
    tmpRule = ruleIndex;
    state = TableState.WaitingConfirm;
    notifyListeners();
  }

  emptyRound() {
    table.newRound(Round.empty(table.id, table.playerNames));
    notifyListeners();
    // db.newRound(table);
    service.update(tableRoute, table);
    service.insert(roundRoute, table.rounds.last);
  }

  roundConfirm() {
    table.newRound(round);
    state = table.gameEnd ? TableState.GameEnd : TableState.WaitingWinner;
    _clearRound();
    notifyListeners();
    // db.newRound(table);
    service.update(tableRoute, table);
    service.insert(roundRoute, table.rounds.last);
  }

  cancelRound() {
    _clearRound();
    state = TableState.WaitingWinner;
    notifyListeners();
  }

  switchPlayer() {
    state = TableState.SwitchingPlayerLeave;
    notifyListeners();
  }

  playerLeaveFound(String playerToLeave) {
    tmpPlayerToLeave = playerToLeave;
    state = TableState.SwitchingPlayerAdd;
    notifyListeners();
  }

  playerAddFound(String playerToAdd) {
    if (table.playerNames.contains(playerToAdd))
      cancelSwitchPlayer();
    else {
      tmpPlayerToAdd = playerToAdd;
      state = TableState.SwitchingPlayerConfirm;
      notifyListeners();
    }
  }

  confirmSwitchPlayer() {
    table.switchPlayer(tmpPlayerToLeave, tmpPlayerToAdd);
    state = TableState.WaitingWinner;
    notifyListeners();
    service.update(tableRoute, table);
    service.insert(roundRoute, table.rounds.last);
  }

  cancelSwitchPlayer() {
    tmpPlayerToAdd = "";
    tmpPlayerToLeave = "";
    state = TableState.WaitingWinner;
    notifyListeners();
  }

  loadHistory() {
    state = TableState.LoadingHistory;
    loadTableHistory();
    notifyListeners();
  }

  restartTable() {
    List<Round> rounds = table.rounds;
    table.restart();
    _clearRound();
    notifyListeners();
    // db.cleanTable(table);
    service.update(tableRoute, table);
    for (Round r in rounds) service.delete(roundRoute, r);
  }

  reviseLastRound() {
    Round lastRound = table.rounds.last;
    table.reviseLastRound();
    service.update(tableRoute, table);
    service.delete(roundRoute, lastRound);
    notifyListeners();
    // db.deleteRound(table.id, lastRoundId);
  }

  reviseLastSwitch() {
    Round lastRound = table.rounds.last;
    table.reviseLastSwitch();
    service.update(tableRoute, table);
    service.delete(roundRoute, lastRound);
    notifyListeners();
    // db.deleteRound(table.id, lastRoundId);
  }

  newTable() {
    table = TableModel.init();
    state = TableState.SettingTable;
    notifyListeners();
  }

  rearrangeSeat() {
    Globals().lastPlayers = table.players;
    table.rearrangeSeat();
    state = TableState.RearrageSeat;
    notifyListeners();
  }

  confirmSeat() {
    state = TableState.SettingStarter;
    notifyListeners();
  }

  gameEnd() {
    table.endGame();
    state = TableState.GameEnd;
    notifyListeners();
  }

  setPlayer(Player player, bool isAdd) {
    table.setTable(player, isAdd);
    notifyListeners();
  }

  continueTable(String tableID) async {
    state = TableState.LoadingTable;
    table = TableModel.init();
    _clearRound();
    notifyListeners();
    // while (!service.checkInit) {}
    await service.queryID(tableRoute, tableID).then((query) {
      if (query.isNotEmpty) {
        table = TableModel.fromMap(query.first);
        service.queryWhere(roundRoute, 'tableID', tableID).then((query) {
          table.rounds = query.map((q) => Round.fromMap(q)).toList();
        });
        setTableID(tableID);
        Timer(Duration(seconds: 1), () {
          state = TableState.WaitingWinner;
          notifyListeners();
        });
      }
    });
  }

  deleteTable(TableModel table) {
    service.delete(tableRoute, table);
    table.rounds.forEach((r) => service.delete(roundRoute, r));

    tableHistory.removeWhere((history) => history.id == table.id);
    if (getTableID == table.id) {
      setTableID("");
    }
    notifyListeners();
  }

  loadTableHistory() async {
    await service.query(tableRoute).then((query) {
      tableHistory = query.map((q) {
        // print(q);
        return TableModel.fromMap(q);
      }).toList();
      // print("---------------loadTableHistory(tables)-------------------");
      // print(tableHistory);
      tableHistory.forEach((t) {
        String tableID = t.id;
        service.queryWhere(roundRoute, 'tableID', tableID).then((query) {
          t.rounds = query.map((q) => Round.fromMap(q)).toList();
          // print("---------------loadTableHistory(rounds)-------------------");
          // print(t.rounds);
          notifyListeners();
        });
      });
    });
  }
}
