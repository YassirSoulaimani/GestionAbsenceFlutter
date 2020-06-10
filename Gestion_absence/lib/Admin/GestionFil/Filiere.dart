class Filiere {
  String id;
  String nomFil;
  String etiquette;
  String description;

  Filiere({
    this.id,
    this.nomFil,
    this.etiquette,
    this.description,
  });

  factory Filiere.fromJson(Map<String, dynamic> json) {
    return Filiere(
      id: json['id'],
      nomFil: json['nomFil'] as String,
      etiquette: json['etiquette'] as String,
      description: json['description'] as String,
    );
  }
}
