import 'package:flutter/material.dart';
import 'package:uionly_flutter/src/api.dart';
import 'package:uionly_flutter/src/oplog.dart';
import 'package:uionly_flutter/src/repository.dart';
import 'package:uionly_flutter/trip_legs/trip_leg.dart';

class AddTripLegView extends StatefulWidget {
  final FitnessActivity? leg;

  const AddTripLegView(this.leg, {super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddTripLegView> {
  final _formKey = GlobalKey<FormState>();
  final date = TextEditingController();
  final type = TextEditingController();
  final duration = TextEditingController();
  final calories = TextEditingController();
  final category = TextEditingController();
  final description = TextEditingController();

  @override
  void initState() {
    if (widget.leg != null) {
      final leg = widget.leg!;
      date.text = leg.date;
      type.text = leg.type;
      duration.text = leg.duration.toString();
      calories.text = leg.calories.toString();
      category.text = leg.category;
      description.text = leg.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                widget.leg == null ? "Add an activity" : "Edit a trip leg")),
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: type,
                      decoration: const InputDecoration(hintText: 'Type'),
                      validator: (String? text) {
                        if (text == null) {
                          return 'Please write something. You stupid.';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: duration,
                          decoration:
                              const InputDecoration(hintText: 'Duration'),
                          validator: (str) => str!.isNotEmpty
                              ? null
                              : 'Please type something idiot',
                        )),
                        Expanded(
                            child: TextFormField(
                          controller: calories,
                          decoration:
                              const InputDecoration(hintText: 'Calories'),
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
                          controller: date,
                          decoration: const InputDecoration(hintText: 'Date'),
                          validator: (str) => str!.isNotEmpty
                              ? null
                              : 'Please type something idiot',
                        )),
                        Expanded(
                            child: TextFormField(
                          controller: category,
                          decoration:
                              const InputDecoration(hintText: 'Category'),
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
                          controller: description,
                          decoration:
                              const InputDecoration(hintText: 'Description'),
                        )),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            var leg = FitnessActivity(
                              date.text,
                              type.text,
                              double.parse(duration.text),
                              double.parse(calories.text),
                              category.text,
                              description.text,
                            );
                            Repository.tryDatabaseOp(context, () async {
                              if (widget.leg != null) {
                                await Repository.instance
                                    .updateOne(widget.leg!.id, leg);
                                await OpLog.instance.addAndTryOperation(
                                    UpdateOperation(
                                        widget.leg!.id, widget.leg!.v, leg));
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
