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
}
