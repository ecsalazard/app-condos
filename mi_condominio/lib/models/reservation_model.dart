class ReservationModel {
  final String id;
  final String spaceName;       // Ej: "Salón de Fiestas", "Área de Parrillera", "Cancha de Tenis"
  final String unitNumber;      // Apartamento que solicita la reserva (Ej: "Torre B - 201")
  final String reservedBy;      // Nombre del propietario o residente responsable
  final String date;            // Fecha de la reserva (Ej: "2026-06-20")
  final String timeSlot;        // Horario (Ej: "2:00 PM - 10:00 PM")
  final String status;          // "Pendiente", "Aprobada", "Rechazada", "Cancelada"
  final double fee;             // Tarifa de uso o depósito de garantía (si aplica)

  ReservationModel({
    required this.id,
    required this.spaceName,
    required this.unitNumber,
    required this.reservedBy,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.fee,
  });

  // Convertir desde JSON (Base de datos)
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'] ?? '',
      spaceName: json['spaceName'] ?? '',
      unitNumber: json['unitNumber'] ?? '',
      reservedBy: json['reservedBy'] ?? '',
      date: json['date'] ?? '',
      timeSlot: json['timeSlot'] ?? '',
      status: json['status'] ?? 'Pendiente',
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Convertir a JSON (Guardar en Base de datos)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spaceName': spaceName,
      'unitNumber': unitNumber,
      'reservedBy': reservedBy,
      'date': date,
      'timeSlot': timeSlot,
      'status': status,
      'fee': fee,
    };
  }
}