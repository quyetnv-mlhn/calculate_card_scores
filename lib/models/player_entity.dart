// To parse this JSON data, do
//
//     final player = playerFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

Player playerFromJson(String str) => Player.fromJson(json.decode(str));

String playerToJson(Player data) => json.encode(data.toJson());

class Player extends Equatable {
  String? name;
  bool? isWinner;
  List<int>? score;

  Player({
    this.name,
    this.isWinner,
    this.score,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        name: json["name"],
        isWinner: json["isWinner"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "isWinner": isWinner,
        "score": score,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [name, isWinner];
}
