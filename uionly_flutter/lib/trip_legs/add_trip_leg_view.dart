import 'package:flutter/material.dart';
import 'package:uionly_flutter/src/api.dart';
import 'package:uionly_flutter/src/oplog.dart';
import 'package:uionly_flutter/src/repository.dart';
import 'package:uionly_flutter/trip_legs/trip_leg.dart';

class AddTripLegView extends StatefulWidget {
  final TripLeg? leg;

  const AddTripLegView(this.leg, {super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddTripLegView> {
  final _formKey = GlobalKey<FormState>();
  final trainNum = TextEditingController();
  final depStation = TextEditingController();
  final arrStation = TextEditingController();
  final depTime = TextEditingController();
  final arrTime = TextEditingController();
  final observations = TextEditingController();

  @override
  void initState() {
    if (widget.leg != null) {
      final leg = widget.leg!;
      trainNum.text = leg.trainNum;
      depStation.text = leg.depStation;
      arrStation.text = leg.arrStation;
      depTime.text = leg.depTime;
      arrTime.text = leg.arrTime;
      observations.text = leg.observations;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                widget.leg == null ? "Add a trip leg" : "Edit a trip leg")),
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: trainNum,
                      decoration:
                          const InputDecoration(hintText: 'Train number'),
                      validator: (String? text) {
                        if (text == null) {
                          return 'Please write something. You stupid.';
                        }
                        if (!RegExp("^(IR|IC|R) ?[0-9]{3,6}\$")
                            .hasMatch(text)) {
                          return 'Your train number is invalid. Please look on your ticket.';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: depStation,
                          decoration:
                              const InputDecoration(hintText: 'From Station'),
                          validator: (str) => str!.isNotEmpty
                              ? null
                              : 'Please type something idiot',
                        )),
                        Expanded(
                            child: TextFormField(
                          controller: arrStation,
                          decoration:
                              const InputDecoration(hintText: 'To Station'),
                          validator: (str) => str!.isNotEmpty
                              ? null
                              : 'Please type something idiot',
                        ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: depTime,
                          decoration:
                              const InputDecoration(hintText: 'From Time'),
                          validator: (str) => str!.isNotEmpty
                              ? null
                              : 'Please type something idiot',
                        )),
                        Expanded(
                            child: TextFormField(
                          controller: arrTime,
                          decoration:
                              const InputDecoration(hintText: 'To Time'),
                          validator: (str) => str!.isNotEmpty
                              ? null
                              : 'Please type something idiot',
                        ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: observations,
                          decoration:
                              const InputDecoration(hintText: 'Observations'),
                        )),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            var leg = TripLeg(
                              trainNum.text,
                              depStation.text,
                              arrStation.text,
                              depTime.text,
                              arrTime.text,
                              observations.text,
                            );
                            Repository.tryDatabaseOp(context, () async {
                              if (widget.leg != null) {
                                await Repository.instance
                                    .updateOne(widget.leg!.trainNum, leg);
                                await OpLog.instance.addAndTryOperation(
                                    UpdateOperation(widget.leg!.trainNum,
                                        widget.leg!.v, leg));
                                // await IHateAPI.update(
                                //     widget.leg!.trainNum, widget.leg!.v, leg);
                              } else {
                                await Repository.instance.insertOne(leg);
                                await OpLog.instance
                                    .addAndTryOperation(CreateOperation(leg));
                                // await IHateAPI.create(leg);
                              }
                            }).then((_) {
                              Navigator.pop(context, leg);
                            });
                          }
                        },
                        child: Text(widget.leg == null
                            ? "Add a trip leg"
                            : "Edit a trip leg"))
                  ])),
        ));
  }
}
