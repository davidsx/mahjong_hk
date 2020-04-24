
enum Wind { East, South, West, North }

class WindUtil {
  final Wind wind;
  WindUtil(this.wind);

  @override
  String toString() => _list[this.wind.index];

  static Wind fromString(String s) =>
      Wind.values[_list.indexWhere((str) => s == str)];

  static final List<String> _list = ['東', '南', '西', '北'];
}
