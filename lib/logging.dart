part of useful;

setupDefaultLogHandler(){
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((LogRecord rec) {
    String errorStr = rec.error == null ? '' : ' ${rec.error}';
    String stackTraceStr = rec.stackTrace == null ? '' : ' ${rec.stackTrace}';
    print('${rec.loggerName} ${rec.loggerName} ${rec.message} ${errorStr} ${stackTraceStr}');
  });
}
