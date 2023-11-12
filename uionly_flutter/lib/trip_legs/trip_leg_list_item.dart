import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uionly_flutter/trip_legs/add_trip_leg_view.dart';
import 'package:uionly_flutter/trip_legs/trip_leg.dart';

class TripLegListItem extends StatelessWidget {
  final TripLeg leg;
  final Function(TripLeg) onDelete;
  final Function(String, TripLeg) onEdit;

  const TripLegListItem(this.leg,
      {super.key, required this.onEdit, required this.onDelete});

  Future<bool> showConfirmationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: const Text("Are you f**** sure?"),
                content: const Text("Are you sure you want to delet this?"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Yes")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("No")),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amberAccent,
      child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(leg.trainNum,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: leg.colorFromRank(),
                  ),
                  PopupMenuButton(
                      itemBuilder: (ctx) => [
                            PopupMenuItem(
                                value: 'edit',
                                child: const Text('Edit'),
                                onTap: () async {
                                  final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              AddTripLegView(leg)));
                                  if (result == null) return;
                                  onEdit(leg.trainNum, result);
                                }),
                            PopupMenuItem(
                              value: 'delete',
                              child: const Text('Delete'),
                              onTap: () async {
                                if (await showConfirmationDialog(context)) {
                                  onDelete(leg);
                                }
                              },
                            ),
                          ])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(leg.depTime, style: const TextStyle(fontSize: 20)),
                  Text(leg.arrTime, style: const TextStyle(fontSize: 20))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(leg.depStation), Text(leg.arrStation)],
              ),
              Text(leg.observations),
            ],
          )),
    );
  }
}
