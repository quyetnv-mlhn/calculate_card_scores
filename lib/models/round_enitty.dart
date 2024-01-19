// To parse this JSON data, do
//
//     final roundEntity = roundEntityFromJson(jsonString);

import 'dart:convert';

RoundEntity roundEntityFromJson(String str) => RoundEntity.fromJson(json.decode(str));

String roundEntityToJson(RoundEntity data) => json.encode(data.toJson());

class RoundEntity {
  int? gameId;
  String? numericalOrder;
  String? timeNow;
  List<int>? data;
  String? note;

  RoundEntity({
    this.gameId,
    this.numericalOrder,
    this.timeNow,
    this.data,
    this.note,
  });

  factory RoundEntity.fromJson(Map<String, dynamic> json) => RoundEntity(
        gameId: json["gameId"],
        numericalOrder: json["numericalOrder"],
        timeNow: json["timeNow"],
        data: json["data"] == null ? [] : List<int>.from(jsonDecode(json["data"])),
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "gameId": gameId,
        "numericalOrder": numericalOrder,
        "timeNow": timeNow,
        "data": jsonEncode(data == null ? [] : List<dynamic>.from(data!.map((x) => x))),
        "note": note,
      };
}
