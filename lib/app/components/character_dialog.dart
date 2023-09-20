import 'package:cinereview/app/components/block_button.dart';
import 'package:cinereview/app/components/custom_form_field.dart';
import 'package:cinereview/app/components/custom_outlined_button.dart';
import 'package:cinereview/app/data/models/character_model.dart';
import 'package:cinereview/app/data/repositories/characters_repository.dart';
import 'package:cinereview/app/styles/colors.dart';
import 'package:cinereview/app/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:provider/provider.dart';

class CharacterDialog extends StatefulWidget {
  final bool updateMode;
  CharacterModel? character;

  CharacterDialog({super.key, this.updateMode = false, this.character});

  @override
  State<CharacterDialog> createState() => _CharacterDialogState();
}

class _CharacterDialogState extends State<CharacterDialog> {
  final linkRgx = RegExp(r'\bhttps?://\S+\.(?:png|jpe?g|gif|bmp|svg|webp)\b');
  final _charName = TextEditingController();
  final _actorName = TextEditingController();
  final _movieTitle = TextEditingController();
  final _imagePath = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late CharactersRepository repositiry;

  void closeDialog(bool update) {
    Navigator.of(context).pop(update);
  }

  void showSnack(String message, bool erro) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: erro ? ProjectColors.pink : Colors.green[800],
      ),
    );
  }

  Future<void> _deleteCharacter() async {
    try {
      await repositiry.deleteCharacter(widget.character!.id);
      showSnack('Personagem deletado', false);
      closeDialog(true);
      closeDialog(true);
    } catch (e) {
      showSnack('Não foi possível deletar a personagem', true);
      closeDialog(false);
    }
  }

  _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ProjectColors.background,
        title: const Text(
          'Excluir personagem?',
          style: ProjectText.tittle,
        ),
        content: SizedBox(
          height: 140,
          width: 200,
          child: Column(
            children: [
              BlockButton(
                label: 'Não',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Spacer(),
              CustomOutlinedButton(
                  onPressed: () {
                    _deleteCharacter();
                  },
                  label: 'Sim')
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    repositiry = Provider.of<CharactersRepository>(context);
    if (widget.updateMode) {
      _actorName.text = widget.character!.actorName;
      _charName.text = widget.character!.name;
      _movieTitle.text = widget.character!.movieTitle;
      _imagePath.text = widget.character!.imagePath;
    }
  }

  Future<void> createCharacter() async {
    try {
      await repositiry.createCharacter(
          _charName.text, _actorName.text, _movieTitle.text, _imagePath.text);
      showSnack('Personagem adicionado com sucesso', false);
      closeDialog(true);
    } catch (e) {
      showSnack('Não foi possível adiciona a personagem', true);
      closeDialog(false);
    }
  }

  Future<void> updateCharacter() async {
    try {
      await repositiry.updateCharacter(
        CharacterModel(widget.character!.id, _charName.text, _actorName.text,
            _movieTitle.text, _imagePath.text),
      );
      showSnack('Personagem editado com sucesso', false);
      closeDialog(true);
    } catch (e) {
      showSnack('Não foi possível editar a personagem', true);
      closeDialog(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ProjectColors.background,
      elevation: 0.0,
      alignment: Alignment.center,
      shadowColor: Colors.black,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.updateMode ? 'Editar\nPersonagem' : 'Adicionar\nPersonagem',
            style: ProjectText.tittle,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              closeDialog(false);
            },
            icon: const Icon(
              PhosphorIcons.x,
              color: Colors.white,
              size: 32,
            ),
          )
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 334,
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(height: 32),
                    CustomFormField(
                      controller: _charName,
                      label: 'Nome',
                      color: ProjectColors.orange,
                      keyType: TextInputType.name,
                      obscureText: false,
                      placeholder: 'Ex.: Harry potter',
                      onChanged: (String a) {},
                      validators: (value) {
                        if (value!.isEmpty) {
                          return 'Informe um nome';
                        }
                        if (value!.length < 6) {
                          return 'Ao menos 5 caractéres';
                        }
                        return null;
                      },
                    ),
                    Container(height: 16),
                    CustomFormField(
                      controller: _actorName,
                      label: 'Ator',
                      color: ProjectColors.orange,
                      keyType: TextInputType.name,
                      obscureText: false,
                      placeholder: 'Ator ou dublador do personagem',
                      onChanged: (String a) {},
                      validators: (value) {
                        if (value!.isEmpty) {
                          return 'Informe um nome';
                        }
                        if (value!.length < 6) {
                          return 'Ao menos 5 caractéres';
                        }
                        return null;
                      },
                    ),
                    Container(height: 16),
                    CustomFormField(
                      controller: _movieTitle,
                      label: 'Título do filme',
                      color: ProjectColors.orange,
                      keyType: TextInputType.name,
                      obscureText: false,
                      placeholder: 'Nome do filme do personagem',
                      onChanged: (String a) {},
                      validators: (value) {
                        if (value!.isEmpty) {
                          return 'Informe um título';
                        }
                        if (value!.length < 6) {
                          return 'Ao menos 5 caractéres';
                        }
                        return null;
                      },
                    ),
                    Container(height: 16),
                    CustomFormField(
                      controller: _imagePath,
                      label: 'URL Imagem',
                      color: ProjectColors.orange,
                      keyType: TextInputType.name,
                      obscureText: false,
                      placeholder: 'Link para imagem do personagem',
                      onChanged: (String a) {},
                      validators: (value) {
                        if (value!.isEmpty) {
                          return 'Informe um link';
                        }
                        if (!linkRgx.hasMatch(value)) {
                          return 'Informe um link válido';
                        }
                        return null;
                      },
                    ),
                    Container(height: 80),
                    widget.updateMode
                        ? Column(
                            children: [
                              BlockButton(
                                label: 'Salvar alterações',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    updateCharacter();
                                  }
                                },
                              ),
                              Container(height: 16),
                              CustomOutlinedButton(
                                onPressed: () {
                                  _showDeleteDialog();
                                },
                                label: 'Excluir',
                              )
                            ],
                          )
                        : Column(
                            children: [
                              BlockButton(
                                label: 'Adicionar personagem',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    createCharacter();
                                  }
                                },
                              ),
                              Container(height: 16),
                              CustomOutlinedButton(
                                onPressed: () {
                                  closeDialog(false);
                                },
                                label: 'Cancelar',
                              )
                            ],
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
