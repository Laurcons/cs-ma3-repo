import 'dart:ui';

import 'package:flutter/material.dart';

class TripLeg {
  String trainNum;
  String depStation;
  String arrStation;
  String depTime;
  String arrTime;
  String observations;
  int v = -1;

  TripLeg(this.trainNum, this.depStation, this.arrStation, this.depTime,
      this.arrTime, this.observations);
  TripLeg.withV(this.trainNum, this.depStation, this.arrStation, this.depTime,
      this.arrTime, this.observations, this.v);

  Color colorFromRank() {
    if (trainNum.startsWith("IC")) return Colors.green;
    if (trainNum.startsWith("IR")) return Colors.redAccent;
    if (trainNum.startsWith("R")) return Colors.black;
    return Colors.white;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'trainNum': trainNum,
      'depStation': depStation,
      'arrStation': arrStation,
      'depTime': depTime,
      'arrTime': arrTime,
      'observations': observations,
    };
    if (v != -1) map['v'] = v;
    return map;
  }

  TripLeg.fromMap(Map<String, Object?> map)
      : trainNum = map['trainNum'] as String,
        depStation = map['depStation'] as String,
        arrStation = map['arrStation'] as String,
        depTime = map['depTime'] as String,
        arrTime = map['arrTime'] as String,
        observations = map['observations'] as String,
        v = map.containsKey('v') ? map['v'] as int : -1;
}
