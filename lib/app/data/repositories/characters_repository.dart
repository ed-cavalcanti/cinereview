import 'dart:async';

import 'package:cinereview/app/data/database/db_firestore.dart';
import 'package:cinereview/app/data/models/character_model.dart';
import 'package:cinereview/app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class CharactersRepository extends ChangeNotifier {
  late FirebaseFirestore db;
  late AuthService auth;
  final _uuid = const Uuid();

  CharactersRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    db = DBFirestore.get();
  }

  Future<void> createCharacter(String charName, String actorName,
      String movieTitle, String imagePath) async {
    final CollectionReference charactersCollection =
        db.collection('characters');

    try {
      charactersCollection.add({
        'id': _uuid.v4(),
        'userId': auth.user!.uid,
        'charName': charName,
        'actorName': actorName,
        'movieTitle': movieTitle,
        'imagePath': imagePath
      });
    } catch (e) {
      throw Exception('Algo deu errado: $e');
    }
  }

  Future<List<CharacterModel>> getUserCharacters() async {
    final CollectionReference charactersCollection =
        db.collection('characters');

    List<CharacterModel> userCharacters = [];

    try {
      QuerySnapshot snapshot = await charactersCollection
          .where('userId', isEqualTo: auth.user!.uid)
          .get();

      for (DocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> dataMap = doc.data() as Map<String, dynamic>;
        userCharacters.add(CharacterModel.fromMap(dataMap));
      }

      return userCharacters;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateCharacter(CharacterModel character) async {
    final CollectionReference charactersCollection =
        db.collection('characters');

    try {
      QuerySnapshot snapshot = await charactersCollection
          .where('userId', isEqualTo: auth.user!.uid)
          .where('id', isEqualTo: character.id)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final DocumentReference characterDoc =
            charactersCollection.doc(snapshot.docs[0].id);

        await characterDoc.update({
          'charName': character.name,
          'actorName': character.actorName,
          'movieTitle': character.movieTitle,
          'imagePath': character.imagePath
        });
      } else {
        throw Exception('Personagem não encontrada com o ID: $character.id');
      }
    } catch (e) {
      throw Exception('Algo deu errado ao editar a personagem');
    }
  }

  Future<void> deleteCharacter(String id) async {
    final CollectionReference charactersCollection =
        db.collection('characters');

    try {
      QuerySnapshot snapshot = await charactersCollection
          .where('userId', isEqualTo: auth.user!.uid)
          .where('id', isEqualTo: id)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await charactersCollection.doc(snapshot.docs[0].id).delete();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
