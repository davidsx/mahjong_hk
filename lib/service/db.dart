// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:mahjong/models/globals.dart';
// import 'package:mahjong/models/player_model.dart';
// import 'package:mahjong/models/round.dart';
// import 'package:mahjong/models/table_model.dart';

// class DatabaseService {
//   String get mjID {
//     print("DatabaseService: get mjID (${Globals().mjID})");
//     if (Globals().mjID.isEmpty) throw ("!!! mjID not set !!!");
//     return Globals().mjID;
//   }

//   DocumentReference mj() => Firestore.instance.collection('MJ').document(mjID);

//   CollectionReference tables() =>
//       Firestore.instance.collection('MJ').document(mjID).collection('tables');

//   CollectionReference players() =>
//       Firestore.instance.collection('MJ').document(mjID).collection('players');

//   // * Create
//   static Future<bool> newMJ(String id, String name) async {
//     if (!(await mjIDExist(id) || await mjNameExist(name))) {
//       await Firestore.instance
//           .collection('MJ')
//           .document(id)
//           .setData({'name': name});
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future newTable(TableModel table) async {
//     await tables().document(table.id).setData(table.toMap());
//     await updateTablePlayer(table);
//   }

//   Future newPlayer(PlayerModel player) async {
//     await players().document(player.id).setData(player.toMap());
//   }

//   Future newRound(TableModel table) async {
//     var newRound = table.rounds.last;
//     await updateTablePlayer(table);
//     await tables()
//         .document(table.id)
//         .collection('rounds')
//         .document(newRound.id)
//         .setData(newRound.toMap());
//     await updateTable(table);
//     await mj().collection('players').document(newRound.winner).get().then((ds) {
//       PlayerModel old =
//           PlayerModel.fromFirestore(ds).balanceChange(newRound.winningAmount);
//       ds.reference.setData(old.toMap());
//     });
//     for (String loser in newRound.loser) {
//       await mj().collection('players').document(loser).get().then((ds) {
//         PlayerModel old =
//             PlayerModel.fromFirestore(ds).balanceChange(newRound.losingAmount);
//         ds.reference.setData(old.toMap());
//       });
//     }
//   }

//   // * Read
//   static Future<String> loadMJName(String id) async {
//     var doc = await Firestore.instance.collection('MJ').document(id).get();
//     return doc.data['name'];
//   }

//   Future<TableModel> loadTable(String id) async {
//     var doc = await tables().document(id).get();
//     return TableModel.fromFirestore(doc);
//   }

//   Future<List<PlayerModel>> loadPlayers() async {
//     var docs = await players().getDocuments();
//     return docs.documents.map((doc) => PlayerModel.fromFirestore(doc)).toList();
//   }

//   // * Update
//   Future updateTable(TableModel table) async {
//     tables().document(table.id).setData(table.toMap());
//   }

//   Future updateTablePlayer(TableModel table) async {
//     CollectionReference tablePlayers =
//         tables().document(table.id).collection('players');
//     for (int i = 0; i < table.players.length; i++) {
//       await tablePlayers
//           .document(table.players[i].id)
//           .setData(table.players[i].toMap()..addAll({'index': i}));
//     }
//   }

//   // * Checking
//   Future<bool> playerExist(PlayerModel player) async {
//     var doc = await players().document(player.id).get();
//     var docs =
//         await players().where('name', isEqualTo: player.name).getDocuments();

//     return (docs.documents.length > 0) && (doc != null && doc.exists);
//   }

//   static Future<bool> mjIDExist(String id) async {
//     var doc = await Firestore.instance.collection('MJ').document(id).get();
//     return (doc != null && doc.exists);
//   }

//   static Future<bool> mjNameExist(String name) async {
//     var docs = await Firestore.instance
//         .collection('MJ')
//         .where('name', isEqualTo: name)
//         .getDocuments();
//     return (docs.documents.length > 0);
//   }

//   // * Delete
//   Future deleteTable(TableModel table) async {
//     await tables().document(table.id).delete();
//   }

//   Future deletePlayer(PlayerModel player) async {
//     await players().document(player.id).delete();
//   }

//   Future deleteRound(String tableId, String roundId) async {
//     await tables()
//         .document(tableId)
//         .collection('rounds')
//         .document(roundId)
//         .delete();
//   }

//   Future cleanTable(TableModel table) async {
//     await tables()
//         .document(table.id)
//         .collection('rounds')
//         .getDocuments()
//         .then((snapshot) {
//       for (DocumentSnapshot ds in snapshot.documents) {
//         ds.reference.delete();
//       }
//     });

//     await updateTablePlayer(table);
//   }

//   // * Stream
//   static Stream<DocumentSnapshot> loadMJs(String id) {
//     return Firestore.instance.collection('MJ').document(id).snapshots();
//   }

//   static Future<DocumentSnapshot> loadMJsFuture(String id) {
//     return Firestore.instance.collection('MJ').document(id).get();
//   }

//   Stream<List<TableModel>> loadTableHistory() {
//     return tables().snapshots().map((snapshot) =>
//         snapshot.documents.map((ds) => TableModel.fromFirestore(ds)).toList());
//   }

//   Stream<List<PlayerModel>> loadTablePlayers(String tableId) {
//     return tables().document(tableId).collection('players').snapshots().map(
//           (snapshot) => List<PlayerModel>.generate(
//             4,
//             (i) => PlayerModel.fromFirestore(
//               snapshot.documents
//                   .firstWhere((ds) => (ds.data['index'] as int) == i),
//             ),
//           ),
//         );
//   }

//   Stream<List<Round>> loadTableRounds(String tableId) {
//     return tables().document(tableId).collection('rounds').snapshots().map(
//         (snapshot) =>
//             snapshot.documents.map((ds) => Round.fromFirestore(ds)).toList());
//   }
// }
