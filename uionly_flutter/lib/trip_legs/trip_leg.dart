import 'dart:ui';

import 'package:flutter/material.dart';

class TripLeg {
  String trainNum;
  String depStation;
  String arrStation;
  String depTime;
  String arrTime;
  String observations;

  TripLeg(this.trainNum, this.depStation, this.arrStation, this.depTime,
      this.arrTime, this.observations);

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
    return map;
  }

  TripLeg.fromMap(Map<String, Object?> map)
      : trainNum = map['trainNum'] as String,
        depStation = map['depStation'] as String,
        arrStation = map['arrStation'] as String,
        depTime = map['depTime'] as String,
        arrTime = map['arrTime'] as String,
        observations = map['observations'] as String;
}
