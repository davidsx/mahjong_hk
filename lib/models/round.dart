import 'package:mahjong/models/base.dart';
import 'package:mahjong/models/globals.dart';
import 'package:mahjong/models/method.dart';
import 'package:uuid/uuid.dart';

enum RoundStatus { Empty, Normal, KeepDealer, ChangeDealer, SwitchPlayer, NewTable }

class Round extends Model {
  String winner;
  List<String> loser;
  List<String> players;
  Method method;
  int ruleIndex;
  int winningAmount;
  int losingAmount;
  String windStage;
  String id;
  String tableId;
  RoundStatus status;

  @override
  String toString() {
    return 'Round { id: $id, winner: $winner, loser: $loser, method: $method, winningAmount: $winningAmount, losingAmount: $losingAmount }';
  }

  factory Round.fromMap(Map<String, dynamic> data) {
    Round tmp = Round.empty("", [""]);

    return Round(
      winner: data['winner'] ?? tmp.winner,
      loser: data['loser'] != null
          ? (data['loser'] as String).split(',')
          : tmp.loser,
      players: data['players'] != null
          ? (data['players'] as String).split(',')
          : tmp.players,
      method:
          data['method'] == null ? Method.values[data['method']] : tmp.method,
      ruleIndex: data['ruleIndex'] ?? tmp.ruleIndex,
      winningAmount: data['winning'] ?? 0,
      losingAmount: data['losing'] ?? 0,
      windStage: data['round'] ?? '',
      // isRoundSame: Model.parseBool(data['isRoundSame']),
      // isDealerChange: Model.parseBool(data['isDealerChange']),
      // isSwitchPlayer: Model.parseBool(data['isSwitchPlayer']),
      status: RoundStatus.values[data['status']],
      id: data['id'],
      tableId: data['tableId'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'tableId': tableId,
        'winner': winner,
        'loser': loser.join(','),
        'players': players.join(','),
        'method': method.index,
        'ruleIndex': ruleIndex,
        'winning': winningAmount,
        'losing': losingAmount,
        'round': windStage,
        // 'isRoundSame': isRoundSame ? 1 : 0,
        // 'isDealerChange': isDealerChange ? 1 : 0,
        // 'isSwitchPlayer': isSwitchPlayer ? 1 : 0,
        'status': status.index,
      };

  Round({
    this.winner,
    this.loser,
    this.players,
    this.method,
    this.ruleIndex,
    this.tableId,
    this.winningAmount,
    this.losingAmount,
    this.windStage,
    // this.isRoundSame,
    // this.isDealerChange,
    // this.isSwitchPlayer,
    this.status,
    id,
  }) : this.id = id ?? Uuid().v4();

  Round.newRound(
    this.winner,
    this.loser,
    this.method,
    this.ruleIndex,
    this.tableId,
    this.players,
    tableRuleIndex,
    tableRuleAmount,
  ) : this.id = Uuid().v4() {
    List<int> ruleset =
        Globals().getRuleSet(tableRuleIndex ?? 0, tableRuleAmount ?? 0);
    if (ruleset.isNotEmpty) {
      this.winningAmount = winningAmount ??
          (MethodUtil(this.method).winningRate * ruleset[ruleIndex]).toInt();
      this.losingAmount = losingAmount ??
          (MethodUtil(this.method).losingRate * ruleset[ruleIndex]).toInt();
    }
  }

  Round.empty(String tableId, List<String> players)
      : id = Uuid().v4(),
        tableId = tableId,
        winner = "",
        loser = [""],
        players = players,
        method = Method.Waiting,
        ruleIndex = 0,
        status = RoundStatus.Empty;

  Round.switchPlayer(String playerToLeave, String playerToAdd, this.tableId, this.players)
      : winner = playerToAdd,
        loser = [playerToLeave],
        method = Method.Waiting,
        ruleIndex = 0,
        // isSwitchPlayer = true,
        id = Uuid().v4();

  String get expression =>
      ruleIndex >= 3 ? "$ruleIndex" + "番" + MethodUtil(method).toString() : "";

  // String get caption => isSwitchPlayer
  //     ? "換人"
  //     : isRoundSame ? isDealerChange ? "冧莊" : "過莊" : windStage;

  addWindStage(String s) => this.windStage = s;

  // addStatus({bool roundSame, bool dealerChange}) {
  //   status = roundSame
  //       ? dealerChange ? RoundStatus.KeepDealer : RoundStatus.ChangeDealer
  //       : RoundStatus.Normal;
  // }
  addStatus(RoundStatus status) => this.status = status;

  // RoundStatus get status => isSwitchPlayer
  //     ? RoundStatus.SwitchPlayer
  //     : isRoundSame
  //         ? isDealerChange ? RoundStatus.KeepDealer : RoundStatus.ChangeDealer
  //         : RoundStatus.Normal;

  String get caption => status == RoundStatus.Normal
      ? windStage
      : ['', '冧莊', '過莊', '換人'][status.index];

  // bool get isRoundSame =>
  //     status == RoundStatus.KeepDealer || status == RoundStatus.ChangeDealer;
  // bool get isDealerChange => status == RoundStatus.Normal || status == RoundStatus.ChangeDealer;
  bool get isNewTable => status == RoundStatus.NewTable;
  bool get isSwitchPlayer => status == RoundStatus.SwitchPlayer;
  bool get isNormal => status == RoundStatus.Normal;
  bool get isKeepDealer => status == RoundStatus.KeepDealer;
  bool get isChangeDealer => status == RoundStatus.ChangeDealer;
}
