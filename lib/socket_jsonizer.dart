library useful.socket_jsonizer;

import 'dart:io';
import 'dart:async';
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:useful/useful.dart';

Logger _logger = new Logger("useful.socket_jsonizer");

Tuple decodeLeadingNum(String message, int pos) {
  // Take while it's a digit
  String numbers = "";
  for (var i = pos; i < message.length; i++) {
    if ((message.codeUnitAt(i) >= 48) && (message.codeUnitAt(i) <= 57)) {
      numbers += message[i];
    } else break;
  }
  // If there are only digits, the leading number is problably not transfered whole
  if ((numbers.length == message.length) || (numbers.isEmpty)) return new Tuple(-1, -1);
  return new Tuple(num.parse(numbers), numbers.length);
}

/**
 * Takes a [message] of potentially concatenated JSONs
 * and returns List of separate JSONs. If the message is incomplete,
 * the incomplete part is stored in [incompleteJson]
 * */
List<String> getJSONs(String message, [Map incompleteJson]) {
  List<String> jsons = [];
  int messageLength = 0;
  int lastAdditionAt = 0;
  _logger.finest("Messages: $message");
  _logger.finest("From previous iteration: $incompleteJson");
  if (incompleteJson == null) incompleteJson = {};
  if (incompleteJson.containsKey("msg")) {
    // Previous JSON was not sent entirely
    message = incompleteJson["msg"] + message;
    _logger.finest("New message: $message");
  }

  int i = 0;

  while (i < message.length) {
    // Beginning of new message
    // Performance upgrade, there's not going to be JSON longer than 10 bil chars..
    // Returns -1 if there are only digits or no digits
    // Assert = message[i] is a beginning of some valid message => the leading
    // few characters determine the length of message
    Tuple messageInfo = decodeLeadingNum(message, i);
    messageLength = messageInfo[0];
    if (messageLength == -1) {
      // Length of string was not sent entirely
      break;
    }
    i += messageInfo[1];
    if (messageLength+i > message.length) {
      // We want to send more chars than this message contains =>
      // it was not sent entirely
      break;
    }
    jsons.add(message.substring(i, i+messageLength));
    lastAdditionAt = i+messageLength;
    i += messageLength;
  }
  if (lastAdditionAt != message.length) {
    // message is incomplete
    incompleteJson["msg"] = message.substring(lastAdditionAt);
  } else incompleteJson["msg"] = "";
  _logger.fine("Jsons: $jsons");
  return jsons;
}

writeJSON(IOSink iosink, dynamic object, {toEncodable(object)}) =>
    iosink.write(prepareObjectToSend(object, toEncodable: toEncodable));

prepareObjectToSend(dynamic object, {toEncodable(object)}) {
  String encoded = JSON.encode(object, toEncodable: toEncodable);
  return "${encoded.length}${encoded}";
}

Stream toJsonStream(Stream stream) =>
    stream.transform(new StreamTransformer(
        (Stream input, bool cancelOnError) {
          StreamController sc = new StreamController.broadcast();
          Map incompleteJson = {};
          input.listen((List<int> data) {
              Iterable jsons = getJSONs(UTF8.decode(data), incompleteJson).map(JSON.decode);
              jsons.forEach(sc.add);
            },
            onError: sc.addError,
            onDone: sc.close,
            cancelOnError: cancelOnError
          );

          return sc.stream.listen(null);
        })
    );