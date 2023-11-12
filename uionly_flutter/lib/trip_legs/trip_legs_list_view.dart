import 'package:flutter/material.dart';
import 'package:uionly_flutter/trip_legs/trip_leg.dart';
import 'package:uionly_flutter/trip_legs/trip_leg_list_item.dart';

class TripLegsListView extends StatefulWidget {
  const TripLegsListView({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TripLegsListView> {
  List<TripLeg> legs = List<TripLeg>.generate(
      1,
      (index) =>
          TripLeg("R 1244", "Cluj-Napoca", "Razboieni", "19:46", "22:24", ""));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Your Train Itinerary'),
            backgroundColor: Colors.amber),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, "/add");
              if (!mounted) return; // docs said this is good practice, so
              setState(() {
                legs.add(result as TripLeg);
              });
            },
            backgroundColor: Colors.amber,
            child: const Icon(Icons.add)),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: ListView.builder(
                  itemCount: legs.length,
                  itemBuilder: (context, index) => TripLegListItem(
                        legs[index],
                        onDelete: (leg) {
                          setState(() {
                            legs.removeWhere((t) => t.trainNum == leg.trainNum);
                          });
                        },
                        onEdit: (trainNum, leg) {
                          setState(() {
                            final idx =
                                legs.indexWhere((t) => t.trainNum == trainNum);
                            legs[idx] = leg;
                          });
                        },
                      ))),
        ]));
  }
}
