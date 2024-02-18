import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uionly_flutter/src/api.dart';
import 'package:uionly_flutter/src/oplog.dart';
import 'package:uionly_flutter/src/repository.dart';
import 'package:uionly_flutter/trip_legs/trip_leg.dart';
import 'package:uionly_flutter/trip_legs/trip_leg_list_item.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProgressView> {
  void initState() {
    super.initState();
    processData();
  }

  Map<String, double> durations = {};
  bool isLoading = true;

  Future<void> processData() async {
    final allActivities = await IHateAPI.fetchAll();
    allActivities.forEach((activ) {
      final month = activ.date.substring(0, 7);
      if (durations.containsKey(month)) {
        var prev = durations[month]!;
        prev += activ.duration;
        durations[month] = prev;
      } else {
        durations[month] = activ.duration;
      }
    });
    final dur = setState(() {
      durations = durations;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Progress'), backgroundColor: Colors.amber),
        body: SizedBox.expand(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: isLoading
                    ? <Widget>[
                        const Padding(padding: EdgeInsets.all(12.0)),
                        const CircularProgressIndicator()
                      ]
                    : [
                        Expanded(
                            child: ListView.builder(
                          itemCount: durations.length,
                          itemBuilder: (ctx, idx) {
                            final key = durations.keys.elementAt(idx);
                            final value = durations[key];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Month $key'),
                                Text('Duration $value')
                              ],
                            );
                          },
                        ))
                      ])));
  }
}
