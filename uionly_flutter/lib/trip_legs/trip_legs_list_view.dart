import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uionly_flutter/src/api.dart';
import 'package:uionly_flutter/src/oplog.dart';
import 'package:uionly_flutter/src/repository.dart';
import 'package:uionly_flutter/trip_legs/trip_leg.dart';
import 'package:uionly_flutter/trip_legs/trip_leg_list_item.dart';

class TripLegsListView extends StatefulWidget {
  const TripLegsListView({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TripLegsListView> {
  void initState() {
    super.initState();
    if (!Repository.instance.isInited) {
      Future.delayed(const Duration(milliseconds: 100),
          () => Navigator.pushNamed(context, '/'));
      return;
    }
    retrieveInitial(context);
  }

  List<String> dates = List<String>.empty(growable: true);
  List<FitnessActivity> legs = List<FitnessActivity>.empty(growable: true);
  String? selectedDate;
  bool isLoading = true;
  bool isConnected = true;

  void configureSocket() {
    // try to establish ws connection, if it doesn't work,
    //  then we declare the network as down
    IHateAPI.configureSocket(onConnect: () {
      OpLog.instance.retryAll();
      setState(() {
        isConnected = true;
      });
    }, onOperation: (op) {
      // if (op['op'] == 'create') {
      Repository.tryDatabaseOp(context, () async {
        log('Activity: $op');
        final leg = op;
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                    title: const Text("New activity added!"),
                    content: Column(
                      children: [
                        TripLegListItem(leg,
                            onEdit: (e, x) {}, onDelete: (e) {})
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          child: const Text("Ok!")),
                    ]));
      });
      // } else if (op['op'] == 'update') {
      //   Repository.tryDatabaseOp(context, () async {
      //     final id = op['id'];
      //     final leg = FitnessActivity.fromMap(op['data']);
      //     await Repository.instance.updateOne(id, leg);
      //     setState(() {
      //       legs = legs.map((item) {
      //         if (item.id == id) return leg;
      //         return item;
      //       }).toList();
      //     });
      //   });
      // } else if (op['op'] == 'delete') {
      //   Repository.tryDatabaseOp(context, () async {
      //     final id = op['id'];
      //     final deleted = await Repository.instance.tryDeleteOne(id);
      //     setState(() {
      //       if (deleted) {
      //         legs.removeWhere((element) => element.id == id);
      //       }
      //     });
      //   });
      // }
    }, onDisconnect: () {
      setState(() {
        isConnected = false;
        // configureSocket();
      });
    });
  }

  Future<void> retrieveInitial(BuildContext context) async {
    configureSocket();
    updateDates();
    retrieveForDate();
  }

  Future<void> updateDates() async {
    List<String>? apiDateList;
    try {
      apiDateList = await IHateAPI.fetchAllDates();
    } catch (err) {/* */}
    if (!context.mounted) return;
    await Repository.tryDatabaseOp(context, () async {
      log('apiDateList $apiDateList');
      if (apiDateList != null) {
        await Repository.instance.persistDates(apiDateList);
      }
      final repoDates = await Repository.instance.findDates();
      log('Repo dates $repoDates}');
      dates.addAll(repoDates);
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<void> retrieveForDate() async {
    if (selectedDate == null) return;
    List<FitnessActivity>? apiList;
    setState(() {
      isLoading = true;
    });
    try {
      apiList = await IHateAPI.fetchAllForDate(selectedDate!);
    } catch (err) {/* */}
    if (!context.mounted) return;
    await Repository.tryDatabaseOp(context, () async {
      log('Api list $apiList');
      if (apiList != null) {
        await Repository.instance.resetWithNewList(apiList);
      }
      final activities =
          await Repository.instance.findAllForDate(selectedDate!);
      setState(() {
        legs = activities;
        isLoading = false;
      });
      log('legs $legs');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Health and Fitness Tracker'),
            backgroundColor: Colors.amber),
        bottomNavigationBar: !isConnected
            ? Padding(
                padding: EdgeInsets.all(16),
                child: Row(children: [
                  Text("No connection"),
                  ElevatedButton(
                      onPressed: () {
                        configureSocket();
                        updateDates();
                        retrieveForDate();
                      },
                      child: const Text("Retry"))
                ]))
            : null,
        floatingActionButton: !isLoading
            ? FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.pushNamed(context, "/add");
                  if (!mounted || result == null) return;
                  updateDates();
                  retrieveForDate();
                },
                backgroundColor: Colors.amber,
                child: const Icon(Icons.add))
            : null,
        body: SizedBox.expand(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: isLoading
              ? <Widget>[
                  const Padding(padding: EdgeInsets.all(12.0)),
                  const CircularProgressIndicator()
                ]
              : [
                  SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          ElevatedButton(
                              child: const Text('Progress'),
                              onPressed: () {
                                Navigator.pushNamed(context, '/progress');
                              }),
                          ElevatedButton(
                              child: const Text('Top'),
                              onPressed: () {
                                Navigator.pushNamed(context, '/top');
                              }),
                        ],
                      )),
                  SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dates.length,
                        itemBuilder: (context, index) => ActionChip(
                          label: Text(dates[index]),
                          onPressed: () {
                            setState(() {
                              selectedDate = dates[index];
                            });
                            retrieveForDate();
                          },
                        ),
                      )),
                  Expanded(
                      child: ListView.builder(
                          itemCount: legs.length,
                          itemBuilder: (context, index) => TripLegListItem(
                                legs[index],
                                onDelete: (leg) {
                                  Repository.tryDatabaseOp(context, () async {
                                    await Repository.instance.deleteOne(leg.id);
                                    await OpLog.instance.addAndTryOperation(
                                        DeleteOperation(leg.id, leg.v));
                                  });
                                  setState(() {
                                    legs.removeWhere((t) => t.id == leg.id);
                                  });
                                },
                                onEdit: (id, leg) {
                                  setState(() {
                                    final idx =
                                        legs.indexWhere((t) => t.id == id);
                                    legs[idx] = leg;
                                  });
                                },
                              )))
                ],
        )));
  }
}
