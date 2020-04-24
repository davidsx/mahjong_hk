class Logger {
  // static final Logger _singleton = Logger._internal();

  // factory Logger() {
  //   return _singleton;
  // }

  // Logger._internal();

  
}

logger(Object content, [String variable = "", String scope = ""]) {
    String log = "";
    if (variable.isNotEmpty) log += "$variable: ";
    if (scope.isNotEmpty) log += "($scope) ";
    log += "$content";

    print(log);
  }