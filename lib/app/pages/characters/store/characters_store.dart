import 'package:cinereview/app/data/http/exceptions.dart';
import 'package:cinereview/app/data/models/character_model.dart';
import 'package:cinereview/app/data/repositories/characters_repository.dart';
import 'package:flutter/foundation.dart';

class CharactersStore {
  final CharactersRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<CharacterModel>> characters =
      ValueNotifier<List<CharacterModel>>([]);

  final ValueNotifier<List<CharacterModel>> filteredCharacters =
      ValueNotifier<List<CharacterModel>>([]);

  final ValueNotifier<String> error = ValueNotifier<String>('');

  CharactersStore({required this.repository});

  Future<void> getUserCharacters() async {
    isLoading.value = true;
    try {
      List<CharacterModel> char = await repository.getUserCharacters();
      characters.value = char;
      filteredCharacters.value = char;
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCharacter(String charName, String actorName,
      String movieTitle, String imagePath) async {
    try {
      await repository.createCharacter(
          charName, actorName, movieTitle, imagePath);
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }
  }

  void filterCharacters(String filter) {
    filteredCharacters.value = characters.value
        .where((character) =>
            character.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }
}
