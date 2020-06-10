class Absence {
  final String idabs;
  final String idmodule;
  final String idetudiant;
  final String status;
  final String date;
  final String heur;

  Absence(
      {this.idabs,
      this.idmodule,
      this.idetudiant,
      this.status,
      this.date,
      this.heur});

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      idabs: json['id_abs'],
      idmodule: json['id_module'] as String,
      idetudiant: json['id_etudiant'] as String,
      status: json['status'] as String,
      date: json['date'] as String,
      heur: json['heur'] as String,
    );
  }
}
