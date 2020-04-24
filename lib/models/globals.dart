import 'dart:math';

import 'package:mahjong/models/player.dart';

class Globals {
  static final _instance = Globals._internal();
  factory Globals() => _instance;
  Globals._internal();

  List<Player> lastPlayers = [];

  List<int> getRuleSet(int maxIndex, int maxAmount) {
    if (maxIndex == 0 || maxAmount == 0)
      return [];
    int calcIndex = maxIndex % 2 == 0 ? maxIndex : maxIndex - 1;
    return List<int>.generate(maxIndex + 1, (i) {
      if (i < 3) {
        return 0;
      } else if (i == 3) {
        return maxAmount ~/ pow(2, (calcIndex / 2).floor() - 1);
      } else if (i > calcIndex) {
        return maxAmount ~/ 2 * 3;
      } else {
        return i % 2 == 1
            ? (maxAmount ~/ pow(2, ((calcIndex - i) / 2).ceil())) ~/ 2 * 3
            : (maxAmount ~/ pow(2, ((calcIndex - i) / 2).ceil()));
      }
    });
  }

  List<int> indexes = [8, 10, 13];
  List<int> amounts = [32, 64, 128, 256, 512];
}

// class Rule {
//   Rule(this.max) {
//     _baseline = max ~/ 8;
//     score = new List<int>();
//     for (int i = 0; i < 3; i++) score.add(0); // * for dummy used only
//     score.add(_baseline); // * 3
//     score.add(_baseline * 2); // * 4
//     score.add(_baseline * 3); // * 5
//     score.add(score[4] * 2); // * 6
//     score.add(score[5] * 2); // * 7
//     score.add(score[6] * 2); // * 8
//     score.add(score[7] * 2); // * 9
//     score.add(score[8] * 2); // * 10
//   }

//   int max;
//   int _baseline;
//   List<int> score;
// }
