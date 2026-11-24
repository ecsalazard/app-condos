class UnitModel {
  final String id;
  final String towerName;            // Ej: "Torre A", "Manzana B", o "Edificio Principal"
  final String unitNumber;           // Ej: "402", "Pintura 3", "Casa 15"
  final String ownerName;            // Nombre del propietario principal
  final String ownerEmail;           // Correo de contacto del propietario
  final double participationCoefficient; // Ej: 0.015 (1.5% del total de los gastos del condominio)
  final String status;               // Ej: "Al día", "Moroso", "Habitado por Inquilino"

  UnitModel({
    required this.id,
    required this.towerName,
    required this.unitNumber,
    required this.ownerName,
    required this.ownerEmail,
    required this.participationCoefficient,
    required this.status,
  });

  // 1. Método para convertir datos desde un mapa/JSON (Base de datos o API) a un objeto UnitModel
  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'] ?? '',
      towerName: json['towerName'] ?? '',
      unitNumber: json['unitNumber'] ?? '',
      ownerName: json['ownerName'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      participationCoefficient: (json['participationCoefficient'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Al día',
    );
  }

  // 2. Método para convertir nuestro objeto UnitModel a un mapa para guardarlo en la base de datos
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'towerName': towerName,
      'unitNumber': unitNumber,
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'participationCoefficient': participationCoefficient,
      'status': status,
    };
  }
}