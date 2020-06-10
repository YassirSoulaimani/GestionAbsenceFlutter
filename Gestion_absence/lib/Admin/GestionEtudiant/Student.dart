class Student {
  String id;
  String email;
  String nom;
  String prenom;
  String password;
  String cne;
  String cin;
  String naissance;
  String filiere;

  Student({
    this.id,
    this.email,
    this.nom,
    this.prenom,
    this.password,
    this.cne,
    this.cin,
    this.naissance,
    this.filiere,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      email: json['email'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      password: json['password'] as String,
      cne: json['CNE'] as String,
      cin: json['CIN'] as String,
      naissance: json['naissance'] as String,
      filiere: json['filiere'] as String,
    );
  }
}
