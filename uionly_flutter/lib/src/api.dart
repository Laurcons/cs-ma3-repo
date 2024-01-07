import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:uionly_flutter/trip_legs/trip_leg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class IHateAPI {
  static const base = 'http://10.0.2.2:3000';
  static const ws = 'http://10.0.2.2:3000';

  static Future<List<TripLeg>> fetchAll() async {
    log('API fetching all');
    final data = await get(Uri.parse('$base/trip-leg'));
    log('API result ${data.body}');
    final legs = jsonDecode(data.body)
        .map<TripLeg>((m) => TripLeg.fromMap(m))
        .toList() as List<TripLeg>;
    log('Parsed legs ${jsonEncode(legs.map((l) => l.toMap()).toList())}');
    return legs;
  }

  static Future create(TripLeg leg) async {
    log('API adding ${leg.toMap()}');
    final data = await post(Uri.parse('$base/trip-leg'),
        body: jsonEncode(leg.toMap()),
        headers: {'content-type': 'application/json'});
    log('API result ${data.body}');
    return jsonDecode(data.body);
  }

  static Future update(String trainNum, int v, TripLeg leg) async {
    log('API updating $trainNum v=$v to ${leg.toMap()}');
    final data = await patch(
        Uri.parse('$base/trip-leg/${Uri.encodeFull(trainNum)}?v=$v'),
        body: jsonEncode(leg.toMap()),
        headers: {'content-type': 'application/json'});
    log('API result ${data.body}');
    return jsonDecode(data.body);
  }

  static Future deleteOne(String trainNum, int v) async {
    log('API deleting $trainNum v=$v');
    final data = await delete(
        Uri.parse('$base/trip-leg/${Uri.encodeFull(trainNum)}?v=$v'));
    log('API result ${data.body}');
    return jsonDecode(data.body);
  }

  static configureSocket(
      {required void Function() onConnect,
      required void Function(dynamic) onOperation,
      required void Function() onDisconnect}) async {
    // final connectCompleter = Completer<void>();
    final sock = IO.io(
        ws,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setPath('/I-AM-HAVING-A-HORRIBLE-TIME')
            .build());
    log('connecting to ws');
    sock.onConnect((_) {
      log('connected to ws');
      onConnect();
      // if (!connectCompleter.isCompleted) connectCompleter.complete();
    });
    sock.on('operation', (data) {
      log("$data");
      onOperation(data);
    });
    sock.onDisconnect((_) {
      onDisconnect();
    });
    // return connectCompleter.future;
  }
}
