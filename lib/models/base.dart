abstract class Model {
  String id;

  static fromMap() {}
  toMap() {}

  static bool parseBool(dynamic data) {
    return data != null ? (data as int) > 0 : false;
  }
}