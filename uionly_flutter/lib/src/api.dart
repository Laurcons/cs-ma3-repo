import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:uionly_flutter/trip_legs/trip_leg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web_socket_channel/web_socket_channel.dart';

class IHateAPI {
  static const base = 'http://10.0.2.2:2425';
  static const ws = 'ws://10.0.2.2:2425';

  static Future<List<String>> fetchAllDates() async {
    log('API fetch dates');
    final data = await get(Uri.parse('$base/dayData'));
    log('API result ${data.body}');
    final dates = (jsonDecode(data.body) as List<dynamic>).cast<String>();
    log('Parsed dates $dates');
    return dates;
  }

  static Future<List<FitnessActivity>> fetchAllForDate(String date) async {
    log('API fetching date $date');
    final data = await get(Uri.parse('$base/activities/$date'));
    log('API result ${data.body}');
    final legs = jsonDecode(data.body)
        .map<FitnessActivity>((m) => FitnessActivity.fromMap(m))
        .toList() as List<FitnessActivity>;
    log('Parsed legs ${jsonEncode(legs.map((l) => l.toMap()).toList())}');
    return legs;
  }

  static Future<List<FitnessActivity>> fetchAll() async {
    log('API fetching all');
    final data = await get(Uri.parse('$base/allActivities'));
    log('API result ${data.body}');
    final legs = jsonDecode(data.body)
        .map<FitnessActivity>((m) => FitnessActivity.fromMap(m))
        .toList() as List<FitnessActivity>;
    log('Parsed legs ${jsonEncode(legs.map((l) => l.toMap()).toList())}');
    return legs;
  }

  static Future create(FitnessActivity leg) async {
    log('API adding ${leg.toMap()}');
    final data = await post(Uri.parse('$base/activity'),
        body: jsonEncode(leg.toMap()),
        headers: {'content-type': 'application/json'});
    log('API result ${data.body}');
    return jsonDecode(data.body);
  }

  static Future update(int id, int v, FitnessActivity leg) async {
    log('API updating $id v=$v to ${leg.toMap()}');
    final data = await patch(
        Uri.parse('$base/activity/${Uri.encodeFull(id.toString())}'),
        body: jsonEncode(leg.toMap()),
        headers: {'content-type': 'application/json'});
    log('API result ${data.body}');
    return jsonDecode(data.body);
  }

  static Future deleteOne(int id, int v) async {
    log('API deleting $id v=$v');
    final data = await delete(
        Uri.parse('$base/activity/${Uri.encodeFull(id.toString())}?v=$v'));
    log('API result ${data.body}');
    return jsonDecode(data.body);
  }

  static configureSocket(
      {required void Function() onConnect,
      required void Function(dynamic) onOperation,
      required void Function() onDisconnect}) async {
    // final connectCompleter = Completer<void>();
    final channel = WebSocketChannel.connect(Uri.parse(ws));
    onConnect();
    log('connecting to ws');
    channel.stream.listen((event) {
      onOperation(FitnessActivity.fromMap(jsonDecode(event)));
    }, onDone: () {
      onDisconnect();
    }, onError: (err) {
      log('WS error $err');
      onDisconnect();
    });
    // sock.onConnect((_) {
    //   log('connected to ws');
    //   onConnect();
    //   // if (!connectCompleter.isCompleted) connectCompleter.complete();
    // });
    // sock.on('operation', (data) {
    //   log("$data");
    //   onOperation(data);
    // });
    // sock.onDisconnect((_) {
    //   onDisconnect();
    // });
    // return connectCompleter.future;
  }
}
