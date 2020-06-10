class Module {
  String id;
  String nomModule;
  String description;
  String idProf;
  String idFil;

  Module({
    this.id,
    this.nomModule,
    this.description,
    this.idProf,
    this.idFil,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id_module'] as String,
      nomModule: json['nomModule'] as String,
      description: json['description'] as String,
      idProf: json['id_Prof'] as String,
      idFil: json['id_Fil'] as String,
    );
  }
}
