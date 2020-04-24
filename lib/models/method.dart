
enum Method { Waiting, SimpleWin, SelfDraw, SelfDrawByOne }

class MethodUtil {
  final Method method;
  MethodUtil(this.method);

  @override
  String toString() => _list[this.method.index];

  static Method fromString(String s) =>
      Method.values[_list.indexWhere((str) => s == str)];

  double get winningRate => _winning[this.method.index];
  double get losingRate => -_losing[this.method.index];

  static final List<String> _list = ['', '出銃', '自摸', '包自摸'];
  final List<double> _winning = [0, 1, 1.5, 1.5];
  final List<double> _losing = [0, 1, 0.5, 1.5];
}