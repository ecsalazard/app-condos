class UserModel {
  final String id;
  final String name;
  final String email;
  final List<String> roles; // Ej: ['Residente', 'Administrador / Junta']
  final String? unitNumber; // Ej: "Torre A - 402" (puede ser nulo si es admin externo)
  final String? phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    this.unitNumber,
    this.phoneNumber,
  });

  // 1. Método para convertir un JSON o mapa de datos (venido de la base de datos) en un Objeto UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roles: List<String>.from(json['roles'] ?? ['Residente']),
      unitNumber: json['unitNumber'],
      phoneNumber: json['phoneNumber'],
    );
  }

  // 2. Método para convertir nuestro objeto UserModel a un mapa (para enviarlo al servidor o base de datos)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles,
      'unitNumber': unitNumber,
      'phoneNumber': phoneNumber,
    };
  }
}