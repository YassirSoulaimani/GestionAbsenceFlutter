class Teacher {
  String id;
  String email;
  String nom;
  String prenom;
  String password;
  String naissance;
  String numTel;

  Teacher({
    this.id,
    this.email,
    this.nom,
    this.prenom,
    this.numTel,
    this.password,
    this.naissance,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      email: json['email'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      password: json['password'] as String,
      numTel: json['numTel'] as String,
      naissance: json['naissance'] as String,
    );
  }
}
