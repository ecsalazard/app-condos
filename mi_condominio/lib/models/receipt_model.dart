class ReceiptModel {
  final String id;
  final String unitNumber;         // Ej: "Torre A - 402" para saber a quién pertenece
  final String period;             // Ej: "Mayo 2026" o "2026-05"
  final double amount;             // Monto total de la cuota de condominio
  final String status;             // "Pendiente", "En Verificación", "Pagado", "Vencido"
  final String? dueDate;           // Fecha límite de pago (ej. "2026-05-30")
  final String? paymentReference;  // Número de transferencia, Zelle o referencia bancaria
  final String? paymentDate;       // Fecha en que el residente reportó el pago
  final String? paymentProofUrl;   // URL o ruta de la foto del comprobante adjunto

  ReceiptModel({
    required this.id,
    required this.unitNumber,
    required this.period,
    required this.amount,
    required this.status,
    this.dueDate,
    this.paymentReference,
    this.paymentDate,
    this.paymentProofUrl,
  });

  // 1. Método para convertir datos desde un mapa/JSON (Base de datos o API) a un objeto ReceiptModel
  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      id: json['id'] ?? '',
      unitNumber: json['unitNumber'] ?? '',
      period: json['period'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Pendiente',
      dueDate: json['dueDate'],
      paymentReference: json['paymentReference'],
      paymentDate: json['paymentDate'],
      paymentProofUrl: json['paymentProofUrl'],
    );
  }

  // 2. Método para convertir nuestro objeto ReceiptModel a un mapa para guardarlo en la base de datos
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unitNumber': unitNumber,
      'period': period,
      'amount': amount,
      'status': status,
      'dueDate': dueDate,
      'paymentReference': paymentReference,
      'paymentDate': paymentDate,
      'paymentProofUrl': paymentProofUrl,
    };
  }
}