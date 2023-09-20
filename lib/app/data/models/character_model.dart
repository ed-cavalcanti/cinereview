class CharacterModel {
  final String id;
  final String name;
  final String actorName;
  final String movieTitle;
  final String imagePath;

  CharacterModel(
      this.id, this.name, this.actorName, this.movieTitle, this.imagePath);

  factory CharacterModel.fromMap(Map<String, dynamic> map) {
    return CharacterModel(
      map['id'],
      map['charName'],
      map['actorName'],
      map['movieTitle'],
      map['imagePath'],
    );
  }
}
