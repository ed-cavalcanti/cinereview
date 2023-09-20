import 'dart:async';

import 'package:cinereview/app/components/character_card.dart';
import 'package:cinereview/app/components/character_dialog.dart';
import 'package:cinereview/app/components/custom_form_field.dart';
import 'package:cinereview/app/components/nav_bar.dart';
import 'package:cinereview/app/data/repositories/characters_repository.dart';
import 'package:cinereview/app/pages/characters/store/characters_store.dart';
import 'package:cinereview/app/services/auth_service.dart';
import 'package:cinereview/app/styles/colors.dart';
import 'package:cinereview/app/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:provider/provider.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late CharactersStore store;
  final search = TextEditingController();

  Timer debounceTimer = Timer(const Duration(seconds: 30), () {});

  @override
  void initState() {
    super.initState();

    store = CharactersStore(
      repository: CharactersRepository(
        auth: Provider.of<AuthService>(context, listen: false),
      ),
    );

    store.getUserCharacters();
  }

  void navigateBack() {
    Navigator.pushNamed(context, '/home');
  }

  void _showAddCharacterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CharacterDialog(),
    ).then(
      (value) => {
        if (value)
          {
            store.getUserCharacters(),
          }
      },
    );
  }

  void onSearchChange(String filter) {
    store.filterCharacters(filter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.background,
      body: AnimatedBuilder(
        animation: Listenable.merge(
          [
            store.filteredCharacters,
            store.characters,
            store.isLoading,
            store.error
          ],
        ),
        builder: (context, child) {
          if (store.isLoading.value) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(height: 32),
                  const Center(
                    child: CircularProgressIndicator(
                      color: ProjectColors.orange,
                    ),
                  ),
                ],
              ),
            );
          }

          if (store.error.value.isNotEmpty) {
            return Column(
              children: [
                Container(height: 32),
                Center(
                  child: Text(
                    store.error.value,
                    style: ProjectText.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }

          if (store.characters.value.isEmpty) {
            return const Center(
              child: Text(
                'Você ainda não adicionou personagens',
                style: ProjectText.bold,
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 64, left: 24, right: 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: navigateBack,
                        icon: const Icon(
                          PhosphorIcons.arrow_left,
                          size: 32,
                        ),
                      ),
                      Container(width: 12),
                      const Text('Meus personagens', style: ProjectText.tittle),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: CustomFormField(
                          onChanged: (String text) {
                            onSearchChange(text);
                          },
                          onTap: () {},
                          controller: search,
                          label: '',
                          color: ProjectColors.orange,
                          keyType: TextInputType.text,
                          obscureText: false,
                          placeholder: 'Filtre seus personagens pelo nome',
                        ),
                      )
                    ],
                  ),
                  Flexible(
                    child: store.filteredCharacters.value.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum Personagem encontrado',
                              style: ProjectText.bold,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(top: 20),
                            shrinkWrap: true,
                            itemCount: store.filteredCharacters.value.length,
                            separatorBuilder: (context, index) {
                              return Container(height: 16);
                            },
                            itemBuilder: (context, index) {
                              return CharacterCard(
                                character:
                                    store.filteredCharacters.value[index],
                                update: store.getUserCharacters,
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              _showAddCharacterDialog(context);
            },
            backgroundColor: ProjectColors.pink,
            child: const Icon(
              PhosphorIcons.plus,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(context, 2),
    );
  }
}
