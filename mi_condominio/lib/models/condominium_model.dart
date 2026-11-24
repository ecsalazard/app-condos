class CondominiumModel {
  final String id;
  final String name;             // Ej: "Residencias El Parque"
  final String address;          // Dirección física del edificio
  final int totalUnits;          // Número total de apartamentos/casas
  final String bankDetails;      // Datos bancarios, Zelle o Pago Móvil para transferencias
  final String currency;         // Moneda oficial de cobro (Ej: "USD", "VES", "EUR")

  CondominiumModel({
    required this.id,
    required this.name,
    required this.address,
    required this.totalUnits,
    required this.bankDetails,
    required this.currency,
  });

  // Convertir desde JSON (Base de datos)
  factory CondominiumModel.fromJson(Map<String, dynamic> json) {
    return CondominiumModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      totalUnits: json['totalUnits'] ?? 0,
      bankDetails: json['bankDetails'] ?? '',
      currency: json['currency'] ?? 'USD',
    );
  }

  // Convertir a JSON (Guardar en Base de datos)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'totalUnits': totalUnits,
      'bankDetails': bankDetails,
      'currency': currency,
    };
  }
}