class FitnessActivity {
  int id = -1;
  String date;
  String type;
  double duration;
  double calories;
  String category;
  String description;
  int v = -1;

  FitnessActivity(this.date, this.type, this.duration, this.calories,
      this.category, this.description);
  FitnessActivity.withId(this.id, this.date, this.type, this.duration,
      this.calories, this.category, this.description);
  FitnessActivity.withV(this.id, this.date, this.type, this.duration,
      this.calories, this.category, this.description, this.v);

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'date': date,
      'type': type,
      'duration': duration,
      'calories': calories,
      'category': category,
      'description': description
    };
    if (id != -1) map['id'] = id;
    if (v != -1) map['v'] = v;
    return map;
  }

  FitnessActivity.fromMap(Map<String, Object?> map)
      : id = map.containsKey('id') ? map['id'] as int : -1,
        date = map['date'] as String,
        type = map['type'] as String,
        duration = double.parse(map['duration'].toString()),
        calories = double.parse(map['calories'].toString()),
        category = map['category'] as String,
        description = map['description'] as String;
  // v = map.containsKey('v') ? map['v'] as int : -1;
}
