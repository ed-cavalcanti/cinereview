import 'package:cinereview/app/components/character_dialog.dart';
import 'package:cinereview/app/data/models/character_model.dart';
import 'package:cinereview/app/styles/colors.dart';
import 'package:cinereview/app/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class CharacterCard extends StatelessWidget {
  final CharacterModel character;
  final Function update;

  const CharacterCard(
      {super.key, required this.character, required this.update});

  void _showCharacterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          CharacterDialog(updateMode: true, character: character),
    ).then(
      (value) => {
        if (value)
          {
            update(),
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showCharacterDialog(context);
      },
      child: Card(
        color: ProjectColors.darkGray,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    character.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: ProjectText.bold24,
                      softWrap: true,
                      overflow: TextOverflow.clip,
                    ),
                    Container(height: 8),
                    Row(
                      children: [
                        const Icon(
                          PhosphorIcons.user_circle_thin,
                          color: Colors.white70,
                        ),
                        Container(width: 6),
                        Text(
                          character.actorName,
                          style: ProjectText.regular,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                    Container(height: 8),
                    Row(
                      children: [
                        const Column(
                          children: [
                            Icon(
                              PhosphorIcons.film_slate_thin,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                        Container(width: 6),
                        SizedBox(
                          width: 180,
                          child: Text(
                            character.movieTitle,
                            style: ProjectText.regular16,
                            softWrap: true,
                            overflow: TextOverflow.clip,
                          ),
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
