import 'dart:collection';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uionly_flutter/src/api.dart';
import 'package:uionly_flutter/src/oplog.dart';
import 'package:uionly_flutter/src/repository.dart';
import 'package:uionly_flutter/trip_legs/trip_leg.dart';
import 'package:uionly_flutter/trip_legs/trip_leg_list_item.dart';

class TopView extends StatefulWidget {
  const TopView({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TopView> {
  void initState() {
    super.initState();
    processData();
  }

  Map<String, int> categories = {};
  bool isLoading = true;

  Future<void> processData() async {
    final allActivities = await IHateAPI.fetchAll();
    allActivities.forEach((activ) {
      if (categories.containsKey(activ.category)) {
        var prev = categories[activ.category]!;
        prev += 1;
        categories[activ.category] = prev;
      } else {
        categories[activ.category] = 1;
      }
    });
    setState(() {
      var sortedKeys = categories.keys.toList(growable: false)
        ..sort((k1, k2) => -1 * categories[k1]!.compareTo(categories[k2]!));
      categories = {for (var k in sortedKeys) k: categories[k]!};
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
                          itemCount: min(3, categories.length),
                          // itemCount: categories.length,
                          itemBuilder: (ctx, idx) {
                            final key = categories.keys.elementAt(idx);
                            final value = categories[key];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [Text(key), Text('Activities $value')],
                            );
                          },
                        ))
                      ])));
  }
}
