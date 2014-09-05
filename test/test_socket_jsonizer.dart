library useful.test.socket_jsonizer;

import 'package:unittest/unittest.dart';
import 'package:useful/socket_jsonizer.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
    server.listen((Socket socket) =>
        toJsonStream(socket).listen((data) {
          expect(data, equals(toSend));
          completed.complete();
        })
    );
    writeJSON(client,toSend);
    return completed.future;
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
}