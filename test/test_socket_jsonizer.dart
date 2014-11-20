library useful.test.socket_jsonizer;

import 'package:unittest/unittest.dart';
import 'package:useful/socket_jsonizer.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:useful/useful.dart';
import 'package:logging/logging.dart';

Logger _logger = new Logger("test.socket_jsonizer");

main() {
  run();
}

run() {

  ServerSocket server;
  Socket client;

  setUp(() {

    var host = "127.0.0.1";
    var port = 27009;

    return ServerSocket.bind(host, port)
      .then((ServerSocket sSocket) => server = sSocket)
      .then((_) => Socket.connect(host, port))
      .then((Socket socket) => client = socket);
  });

  tearDown(() {
    return client.close().then((_) => server.close());
  });

  test("Should decode a single map", () {
    Completer completed = new Completer();
    Map toSend = {"some": "thing", "in" : ["list", {"and" : {"map": "&"} }], "stuff": 8};
    var received;
    server.listen((Socket socket) =>
        toJsonStream(socket).listen((data) {
          received = data;
        })
    );
    writeJSON(client,toSend);
    return new Future.delayed(new Duration(milliseconds: 500), () => expect(received, equals(toSend)));
  });

  test("Should decode many objects sent one after another (3000)", () {
    var sentId = 0;
    Map template = {"some": "thing", "in" : ["list", {"and" : {"map": "&"} }], "stuff": 8, "i":sentId};
    var amount = 3000;
    List itemsReceived = [];
    List itemsToSend = new Iterable.generate(amount, (i) => (new Map.from(template))..["i"] = i).toList();

    server.listen((Socket socket) {
      toJsonStream(socket).listen(itemsReceived.add);
    });
    for (var i = 0; i < amount; i++) {
      writeJSON(client, template..["i"] = sentId);
      sentId++;
    }

    return new Future.delayed(new Duration(milliseconds: 700), () => expect(itemsToSend, equals(itemsReceived)));
  });

  test("Should decode objects properly not matter how much are they sliced", () {

    List itemsReceived = [];

    JSON.decode('"aa"');

    server.listen((Socket socket) =>
        toJsonStream(socket).listen(itemsReceived.add));

    runTest() {

      Map data = {"some": "random"};
      itemsReceived.clear();

      var delayMs = 10;
      var slices = 50;

      String toSend = "";

      List itemsSent = [];

      for (var i = 0; i < 10; i++) {
        data.addAll({"key$i": "val$i"});
        toSend += prepareObjectToSend(data);
        itemsSent.add(new Map.from(data));
      }
      List<String> sliceRandomly(String str, int number) {
        if (number > str.length) throw new Exception("more slices than str length..");
        Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
        Map slices = {};
        for (var i = 0; i < number; i++) {
          var val = 1+rnd.nextInt(str.length-2);
          while (slices.containsKey(val)) {
            val = rnd.nextInt(str.length);
          }
          slices[val] = true;
        }
        List slicesSorted = slices.keys.toList();
        sort(slicesSorted);
        slicesSorted.insert(0, 0);
        slicesSorted.add(str.length);
        List strings = [];
        for (var i = 1; i < slicesSorted.length; i++) {
          strings.add(str.substring(slicesSorted[i-1],slicesSorted[i]));
        }
        return strings;
      }

      List<String> stringsToSend = sliceRandomly(toSend, slices);
      stringsToSend.forEach((s) => _logger.finer("Will send:$s"));

      return Future.forEach(stringsToSend, (str) => new Future.delayed(new Duration(milliseconds:delayMs), () => client.write(str)))
          .then((_) => new Future.delayed(new Duration(milliseconds: 500),
              () => expect(itemsSent, equals(itemsReceived))));

    }
    // Run this randomized test 10 times
    return Future.forEach(new Iterable.generate(10), (f) => runTest());

  });

  test("toEncodable can be used in prepareObjectToSend", () {
    var nonEncodable = {"d": new Duration()};
    expect(() => prepareObjectToSend(nonEncodable), throws);
    expect(
        prepareObjectToSend(nonEncodable, toEncodable: (o) => "0:00:00"),
        '15{"d":"0:00:00"}');
  });


}