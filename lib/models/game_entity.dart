// To parse this JSON data, do
//
//     final gameEntity = gameEntityFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

GameEntity gameEntityFromJson(String str) => GameEntity.fromJson(json.decode(str));

class GameEntity extends Equatable {
  int? gameId;
  String? timestamp;
  List<String>? players;
  String? winner;
  List<List<int>>? lastScore;

  GameEntity({
    this.gameId,
    this.timestamp,
    this.players,
    this.winner,
    this.lastScore,
  });

  factory GameEntity.fromJson(Map<String, dynamic> json) {
    List<dynamic>? listScoreOfPlayer;
    List<List<int>> lastScore = [[]];
    if (json["lastScore"] != null) {
      listScoreOfPlayer = jsonDecode(json['lastScore']);
      lastScore = List<List<int>>.from(
        listScoreOfPlayer!.map((dynamic row) {
          return List<int>.from(row);
        }),
      );
    }
    return GameEntity(
      gameId: json["gameId"],
      timestamp: json["timestamp"],
      // DateFormat('dd/MM - HH:mm').format(DateTime.parse()),
      players: json["players"] == null
          ? []
          : List<String?>.from(jsonDecode(json["players"])).where((element) => element != null).cast<String>().toList(),
      winner: json["winner"],
      lastScore: json["lastScore"] == null ? [[]] : lastScore,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [gameId, timestamp, players, winner, lastScore];

// Map<String, dynamic> toJson() => {
//       "gameId": gameId,
//       "timestamp": timestamp,
//       "players": jsonEncode(players == null ? [] : List<dynamic>.from(players!.map((x) => x))),
//       "winner": winner,
//       "lastScore": jsonEncode(lastScore == null ? [] : List<dynamic>.from(lastScore!.map((x) => x))),
//     };
}
