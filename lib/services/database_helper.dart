import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../components/commons.dart';
import '../models/player_entity.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> database() async {
    if (_database != null) return _database!;

    // If _database is null, initialize it
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), dbName);

    return await openDatabase(
      path,
      onCreate: (db, version) async {
        // Add more tables for player scores if needed
        // Example: CREATE TABLE player_scores (game_id INTEGER, player_name TEXT, score INTEGER)
        await db.execute('''
          CREATE TABLE $gamesTable (
            gameId INTEGER PRIMARY KEY autoincrement, 
            timestamp TEXT, 
            players TEXT, 
            winner TEXT,
            lastScore TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE $roundsTable (
            gameId INTEGER, 
            numericalOrder TEXT PRIMARY KEY, 
            timeNow TEXT, 
            data TEXT, 
            note TEXT 
          )
        ''');
      },
      version: 1,
    );
  }

  Future<int> addGame({String? winner, required String players, String? lastScore}) async {
    final timestamp = DateTime.now().toIso8601String();

    final gameId = await _database!.insert(
      gamesTable,
      {'timestamp': timestamp, 'winner': winner, 'players': players, 'lastScore': lastScore},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return gameId;
  }

  Future<void> updateGame(int gameId, String winner, String lastScore) async {
    final timestamp = DateTime.now().toIso8601String();
    await _database!.rawUpdate('UPDATE $gamesTable SET winner = ?, timestamp = ?, lastScore = ? WHERE gameId = ?',
        [winner, timestamp, lastScore, gameId]);
  }

  Future<void> deleteGame(int gameId) async {
    await _database!.delete(gamesTable, where: 'gameId = ?', whereArgs: [gameId]);
    await _database!.delete(roundsTable, where: 'gameId = ?', whereArgs: [gameId]);
  }

  Future<void> addRound(int gameId, Map<String, dynamic> playerScores) async {
    final roundData = <String, dynamic>{
      'gameId': gameId,
      ...playerScores,
    };

    await _database!.insert(roundsTable, roundData, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
