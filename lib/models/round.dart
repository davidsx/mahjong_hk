import 'package:mahjong/models/base.dart';
import 'package:mahjong/models/method.dart';
import 'package:uuid/uuid.dart';

enum RoundStatus { Empty, KeepDealer, ChangeDealer, SwitchPlayer, NewTable }

class Round extends Model {
  final String id;
  final String tableId;
  final String winner;
  final List<String> loser;
  final List<String> players;
  final Method method;
  final int ruleIndex;
  final int winningAmount;
  final int losingAmount;
  //String windStage;
  final int roundStage;
  // final String roundCaption;
  final RoundStatus status;

  @override
  String toString() {
    return 'Round { id: $id, winner: $winner, loser: $loser, method: $method, winningAmount: $winningAmount, losingAmount: $losingAmount }';
  }

  factory Round.fromMap(Map<String, dynamic> data) {
    // Round tmp = Round.empty("", [""], );

    return Round(
      id: data['id'],
      tableId: data['tableId'],
      winner: data['winner'] ?? '',
      loser: data['loser'] != null
          ? (data['loser'] as String).split(',')
          : [''],
      players: data['players'] != null
          ? (data['players'] as String).split(',')
          : [''],
      method:
          data['method'] == null ? Method.values[data['method']] : Method.Waiting,
      ruleIndex: data['ruleIndex'] ?? 0,
      winningAmount: data['winningAmount'] ?? 0,
      losingAmount: data['losingAmount'] ?? 0,
      roundStage: data['roundStage'] ?? 99,
      status: RoundStatus.values[data['status']],
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
        'winningAmount': winningAmount,
        'losingAmount': losingAmount,
        'roundStage': roundStage,
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
    this.roundStage,
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
    this.roundStage,
    this.winningAmount,
    this.losingAmount,
    this.status
  ) : this.id = Uuid().v4();

  Round.empty(String tableId, List<String> players, int roundStage, bool isLastRound)
      : id = Uuid().v4(),
        tableId = tableId,
        winner = "",
        loser = [""],
        players = players,
        method = Method.Waiting,
        ruleIndex = 0,
        roundStage = roundStage,
        status = isLastRound ? RoundStatus.KeepDealer : RoundStatus.ChangeDealer,
        winningAmount = 0,
        losingAmount = 0;

  Round.switchPlayer(String playerToLeave, String playerToAdd, this.tableId, this.players, int roundStage)
      : winner = playerToAdd,
        loser = [playerToLeave],
        method = Method.Waiting,
        ruleIndex = 0,
        // isSwitchPlayer = true,
        roundStage = roundStage,
        status = RoundStatus.KeepDealer,
        winningAmount = 0,
        losingAmount = 0,
        id = Uuid().v4();

  String get ruleAndMethodStr =>
      ruleIndex >= 3 ? "$ruleIndex" + "番" + MethodUtil(method).toString() : "";

  bool get isNewTable => status == RoundStatus.NewTable;
  bool get isSwitchPlayer => status == RoundStatus.SwitchPlayer;
  //bool get isNormal => status == RoundStatus.Normal;
  bool get isKeepDealer => status == RoundStatus.KeepDealer;
  bool get isChangeDealer => status == RoundStatus.ChangeDealer;

  String get roundCaption => ['流局','冧莊','過莊','換人','執位'][RoundStatus.values.indexOf(status)];
}
