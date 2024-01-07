import 'dart:collection';

import 'package:uionly_flutter/src/api.dart';
import 'package:uionly_flutter/trip_legs/trip_leg.dart';

class OpLog {
  static final OpLog instance = OpLog();
  final Queue<Operation> queue = Queue();

  void addOperation(Operation op) {
    queue.add(op);
  }

  Future addAndTryOperation(Operation op) async {
    try {
      await op.operate();
    } catch (error) {
      queue.add(op);
    }
  }

  Future retryAll() async {
    for (Operation op in queue.toList()) {
      try {
        await op.operate();
      } catch (error) {
        //
      } finally {
        queue.remove(op);
      }
    }
  }
}

abstract class Operation {
  Future operate();
}

class CreateOperation extends Operation {
  final TripLeg leg;
  CreateOperation(this.leg);

  @override
  Future operate() async {
    await IHateAPI.create(leg);
  }
}

class UpdateOperation extends Operation {
  final String trainNum;
  final int v;
  final TripLeg updates;
  UpdateOperation(this.trainNum, this.v, this.updates);

  @override
  Future operate() async {
    await IHateAPI.update(trainNum, v, updates);
  }
}

class DeleteOperation extends Operation {
  final String trainNum;
  final int v;
  DeleteOperation(this.trainNum, this.v);

  @override
  Future operate() async {
    await IHateAPI.deleteOne(trainNum, v);
  }
}
