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

  List<TripLeg> legs = List<TripLeg>.empty(growable: true);
  bool isLoading = true;
  bool isConnected = false;

  Future<void> retrieveInitial(BuildContext context) async {
    // try to establish ws connection, if it doesn't work,
    //  then we declare the network as down
    IHateAPI.configureSocket(onConnect: () {
      OpLog.instance.retryAll();
      setState(() {
        isConnected = true;
      });
    }, onOperation: (op) {
      if (op['op'] == 'create') {
        Repository.tryDatabaseOp(context, () async {
          final leg = TripLeg.fromMap(op['data']);
          final added = await Repository.instance.tryInsertOne(leg);
          setState(() {
            if (added) legs.add(leg);
          });
        });
      } else if (op['op'] == 'update') {
        Repository.tryDatabaseOp(context, () async {
          final trainNum = op['id'];
          final leg = TripLeg.fromMap(op['data']);
          await Repository.instance.updateOne(trainNum, leg);
          setState(() {
            legs = legs.map((item) {
              if (item.trainNum == trainNum) return leg;
              return item;
            }).toList();
          });
        });
      } else if (op['op'] == 'delete') {
        Repository.tryDatabaseOp(context, () async {
          final trainNum = op['id'];
          final deleted = await Repository.instance.tryDeleteOne(trainNum);
          setState(() {
            if (deleted) {
              legs.removeWhere((element) => element.trainNum == trainNum);
            }
          });
        });
      }
    }, onDisconnect: () {
      setState(() {
        isConnected = false;
      });
    });
    List<TripLeg>? apiList;
    try {
      apiList = await IHateAPI.fetchAll();
    } catch (err) {/* */}
    if (!context.mounted) return;
    await Repository.tryDatabaseOp(context, () async {
      if (apiList != null) await Repository.instance.resetWithNewList(apiList);
      legs.addAll(await Repository.instance.findAll());
    });
    if (!context.mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Your Train Itinerary'),
            backgroundColor: Colors.amber),
        bottomNavigationBar: !isConnected
            ? const Padding(
                padding: EdgeInsets.all(16), child: Text("No connection"))
            : null,
        floatingActionButton: !isLoading
            ? FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.pushNamed(context, "/add");
                  if (!mounted || result == null) return;
                  setState(() {
                    legs.add(result as TripLeg);
                  });
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
                  Expanded(
                      child: ListView.builder(
                          itemCount: legs.length,
                          itemBuilder: (context, index) => TripLegListItem(
                                legs[index],
                                onDelete: (leg) {
                                  Repository.tryDatabaseOp(context, () async {
                                    await Repository.instance
                                        .deleteOne(leg.trainNum);
                                    await OpLog.instance.addAndTryOperation(
                                        DeleteOperation(leg.trainNum, leg.v));
                                  });
                                  setState(() {
                                    legs.removeWhere(
                                        (t) => t.trainNum == leg.trainNum);
                                  });
                                },
                                onEdit: (trainNum, leg) {
                                  setState(() {
                                    final idx = legs.indexWhere(
                                        (t) => t.trainNum == trainNum);
                                    legs[idx] = leg;
                                  });
                                },
                              )))
                ],
        )));
  }
}
