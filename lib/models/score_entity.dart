// To parse this JSON data, do
//
//     final score = scoreFromJson(jsonString);

import 'dart:convert';

ScoreEntity scoreFromJson(String str) => ScoreEntity.fromJson(json.decode(str));

String scoreToJson(ScoreEntity data) => json.encode(data.toJson());

class ScoreEntity {
  int? numericalOrder;
  String? timeNow;
  List<int>? data;
  String? note;

  ScoreEntity({
    this.numericalOrder,
    this.timeNow,
    this.data,
    this.note,
  });

  factory ScoreEntity.fromJson(Map<String, dynamic> json) => ScoreEntity(
        numericalOrder: json["numericalOrder"],
        timeNow: json["timeNow"],
        data: json["data"] == null ? [] : List<int>.from(json["data"]!.map((x) => x)),
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "numericalOrder": numericalOrder,
        "timeNow": timeNow,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
        "note": note,
      };
}
