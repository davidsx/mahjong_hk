import 'package:mahjong/models/base.dart';
import 'package:mahjong/models/player.dart';
import 'package:mahjong/models/round.dart';
import 'package:mahjong/models/wind.dart';
import 'package:uuid/uuid.dart';

class TableModel extends Model {
  String id;
  List<Player> players;
  int dealer;
  int starter;
  Wind wind;
  int stage;
  List<Round> rounds;
  int ruleIndex, ruleAmount;
  bool gameEnd;
  bool gameStart;
  DateTime lastUpdated;

  List<List<Round>> get history {
    List<List<Round>> result = new List<List<Round>>();
    List<Round> tmpRounds = new List<Round>.from(rounds);
    int nextStop =
        tmpRounds.indexWhere((r) => r.isSwitchPlayer || r.isNewTable);
    while (nextStop > 0) {
      result.add(tmpRounds.take(nextStop + 1).toList());
      tmpRounds.removeRange(0, nextStop + 1);
      nextStop = tmpRounds.indexWhere((r) => r.isSwitchPlayer || r.isNewTable);
    }
    result.add(tmpRounds);
    return result;
  }

  List<List<String>> get historyPlayers {
    List<List<String>> result = new List<List<String>>();
    if (rounds.isEmpty) {
      result.add(playerNames);
    } else {
      result.add(rounds.first.players);
      result.addAll(
          rounds.where((r) => r.isSwitchPlayer).map((r) => r.players).toList());
    }

    return result;
  }

  @override
  String toString() {
    return 'Table { id: $id, players: $players, wind: $wind, stage: $stage }';
  }

  TableModel({
    this.players,
    this.dealer,
    this.starter,
    this.wind,
    this.stage,
    this.rounds,
    this.gameEnd,
    this.gameStart,
    this.lastUpdated,
    this.ruleIndex,
    this.ruleAmount,
    String id,
  }) : this.id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() => {
        'id': id,
        'players': players.map((p) => "${p.name}:${p.balance}").join(';'),
        // 'rounds': rounds.map((r) => r.toArray()),
        'starter': starter,
        'dealer': dealer,
        'wind': WindUtil(wind).toString(),
        'stage': stage,
        'gameStart': gameStart ? 1 : 0,
        'gameEnd': gameEnd ? 1 : 0,
        'lastUpdated': DateTime.now().toIso8601String(),
        'ruleIndex': ruleIndex,
        'ruleAmount': ruleAmount,
      };

  factory TableModel.fromMap(Map<String, dynamic> data) {
    TableModel tmp = TableModel.init();

    // Globals().ruleIndex = data['ruleIndex'];
    // Globals().ruleAmount = data['ruleAmount'];

    return TableModel(
      players: (data['players'] as String).split(';').map((p) {
        String name = p.split(':').first;
        String balance = p.split(':').last;
        return Player(name, balance: int.parse(balance));
      }).toList(),
      starter: data['starter'] ?? tmp.starter,
      dealer: data['dealer'] ?? tmp.dealer,
      wind: data['wind'] != null ? WindUtil.fromString(data['wind']) : tmp.wind,
      stage: data['stage'] ?? tmp.stage,
      gameStart: Model.parseBool(data['gameStart']),
      gameEnd: Model.parseBool(data['gameEnd']),
      lastUpdated: data['lastUpdated'] != null
          ? DateTime.parse(data['lastUpdated'])
          : DateTime.now(),
      // lastUpdated: DateTime.now(),
      id: data['id'],
      ruleIndex: data['ruleIndex'] ?? tmp.ruleIndex,
      ruleAmount: data['ruleAmount'] ?? tmp.ruleAmount,
    );
  }

  TableModel.init()
      : this.wind = Wind.East,
        this.stage = 1,
        this.dealer = -1,
        this.starter = -1,
        this.players = [
          Player.init(),
          Player.init(),
          Player.init(),
          Player.init(),
        ],
        this.rounds = List<Round>(),
        this.gameEnd = false,
        this.gameStart = false,
        this.id = "",
        this.lastUpdated = DateTime.now(),
        this.ruleIndex = 0,
        this.ruleAmount = 0;

  String get currentWindStage =>
      WindUtil(this.wind).toString() + '${this.stage}';

  bool get isLastGame => this.stage == 4 && this.wind == Wind.North;

  bool get isGameReady =>
      starter > 0 && dealer > 0 && players.every((p) => p.active);

  bool get isRoundSame => this.rounds.isNotEmpty
      ? this.rounds.last.windStage == this.currentWindStage
      : false;

  bool get isPlayerSwitched =>
      this.rounds.isNotEmpty ? this.rounds.any((r) => r.isSwitchPlayer) : false;

  bool get isPlayerReady => this.players.where((p) => p.active).length >= 4;

  List<String> get playerNames => players.map((p) => p.name).toList();

  void setRule(int ruleIndex, int ruleAmount) {
    this.ruleIndex = ruleIndex;
    this.ruleAmount = ruleAmount;
  }

  void setPlayer(List<String> playerNames) =>
      this.players = List<Player>.generate(4, (i) => Player(playerNames[i]));

  void rotateSeat() {
    this.players =
        List<Player>.generate(4, (i) => this.players[i == 0 ? 3 : i - 1]);
    this.starter += 1;
    if (this.starter >= 4) this.starter = 0;
    this.dealer +=1;
    if (this.dealer >= 4) this.dealer = 0;
  }

  void setStarter(String starterName) {
    dealer = this.players.indexWhere((p) => p.name == starterName);
    starter = this.players.indexWhere((p) => p.name == starterName);
  }

  void startGame() {
    this.id = Uuid().v4();
    this.gameStart = true;
  }

  void endGame() => this.gameEnd = true;

  void newRound(Round round) {
    bool dealerChange =
        this.dealer != this.players.indexWhere((p) => p.name == round.winner);
    Round lastRound = this.rounds.isNotEmpty ? this.rounds.last : null;
    RoundStatus status = lastRound == null ||
            lastRound.isChangeDealer ||
            lastRound.isSwitchPlayer
        ? RoundStatus.Normal
        : dealerChange
            ? lastRound.isKeepDealer
                ? RoundStatus.ChangeDealer
                : RoundStatus.Normal
            : RoundStatus.KeepDealer;

    this.players.forEach((p) => p.balanceChange(p.name == round.winner
        ? round.winningAmount
        : round.loser.contains(p.name) ? round.losingAmount : 0));
    if (dealerChange && !isLastGame) {
      wind = this.stage == 4 ? Wind.values[this.wind.index + 1] : this.wind;
      stage = this.stage == 4 ? 1 : this.stage + 1;
      dealer = (this.dealer + 1) >= 4 ? 0 : this.dealer + 1;
    }
    this.rounds.add(round
      ..addWindStage(this.currentWindStage)
      ..addStatus(status));
    this.gameEnd = dealerChange && isLastGame;
  }

  void switchPlayer(String playerToLeave, String playerToAdd) {
    this.players.firstWhere((p) => p.name == playerToLeave).name = playerToAdd;
    if (rounds.isNotEmpty) {
      Round round =
          Round.switchPlayer(playerToLeave, playerToAdd, id, playerNames);
      this.rounds.add(round
        ..addWindStage(this.currentWindStage)
        ..addStatus(RoundStatus.SwitchPlayer));
    }
  }

  void restart() {
    players.forEach((p) => p.balanceEmpty());
    dealer = this.starter;
    wind = Wind.East;
    stage = 1;
    rounds = List<Round>();
    gameEnd = false;
  }

  void reviseLastRound() {
    players.forEach((p) => p.balanceChange(p.name == this.rounds.last.winner
        ? -this.rounds.last.winningAmount
        : this.rounds.last.loser.contains(p.name)
            ? -this.rounds.last.losingAmount
            : 0));
    if (!this.isRoundSame) {
      this.stage = this.stage == 1 ? 4 : this.stage - 1;
      this.wind = this.stage == 1
          ? this.wind == Wind.East
              ? Wind.East
              : Wind.values[this.wind.index - 1]
          : this.wind;
    } else {
      this.dealer = this.dealer == 0 ? 3 : this.dealer - 1;
    }
    rounds.removeLast();
  }

  void reviseLastSwitch() {
    Round lastRound = rounds.last;
    players.firstWhere((p) => p.name == lastRound.winner).name =
        lastRound.loser.first;
    rounds.removeLast();
  }

  void rearrangeSeat() {
    this.gameStart = false;
    this.gameEnd = false;
    this.players = [
      Player.init(),
      Player.init(),
      Player.init(),
      Player.init(),
    ];
    this.wind = Wind.East;
    this.stage = 1;
    this.dealer = -1;
    this.starter = -1;
  }

  void setTable(Player player, bool isAdd) {
    if (player.name.isNotEmpty) {
      isAdd
          ? players.firstWhere((p) => p.name.isEmpty).setPlayer(player)
          : players
              .firstWhere((p) => p.name == player.name)
              .setPlayer(Player.init());
    }
  }
}
