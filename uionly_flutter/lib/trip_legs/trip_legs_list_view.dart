import 'package:flutter/material.dart';
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

  Future<void> retrieveInitial(BuildContext context) async {
    await Repository.tryDatabaseOp(context, () async {
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
