class EquipoFields {
  static const List<String> values = [
    id,
    name,
    foundingYear,
    lastChampionshipDate,
  ];

  static const String tableName = 'equipos'; 

  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  static const String dateType = 'TEXT NOT NULL'; 

  static const String id = 'id'; 
  static const String name = 'name'; 
  static const String foundingYear = 'founding_year'; 
  static const String lastChampionshipDate = 'last_championship_date';
}

class Equipo {
  int? id;
  final String name;
  final int foundingYear;
  final DateTime lastChampionshipDate;

  Equipo({
    this.id,
    required this.name,
    required this.foundingYear,
    required this.lastChampionshipDate,
  });

  Map<String, Object?> toJson() => {
        EquipoFields.id: id,
        EquipoFields.name: name,
        EquipoFields.foundingYear: foundingYear,
        EquipoFields.lastChampionshipDate:
            lastChampionshipDate.toIso8601String(), 
      };

  factory Equipo.fromJson(Map<String, Object?> json) => Equipo(
        id: json[EquipoFields.id] as int?,
        name: json[EquipoFields.name] as String,
        foundingYear: json[EquipoFields.foundingYear] as int,
        lastChampionshipDate:
            DateTime.tryParse(json[EquipoFields.lastChampionshipDate] as String? ?? '') ?? DateTime.now(),
      );

  Equipo copy({
    int? id,
    String? name,
    int? foundingYear,
    DateTime? lastChampionshipDate,
  }) =>
      Equipo(
        id: id ?? this.id,
        name: name ?? this.name,
        foundingYear: foundingYear ?? this.foundingYear,
        lastChampionshipDate: lastChampionshipDate ?? this.lastChampionshipDate,
      );
}