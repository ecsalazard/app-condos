import 'package:flutter/material.dart';
import '../../models/reservation_model.dart';
import '../../widgets/custom_button.dart';

class AdminReservationsView extends StatefulWidget {
  const AdminReservationsView({super.key});

  @override
  State<AdminReservationsView> createState() => _AdminReservationsViewState();
}

class _AdminReservationsViewState extends State<AdminReservationsView> {
  // Lista simulada de reservas pendientes de aprobación
  final List<ReservationModel> _pendingReservations = [
    ReservationModel(
      id: 'res_01',
      spaceName: 'Salón de Fiestas',
      unitNumber: 'Torre A - 402',
      reservedBy: 'carlos@correo.com',
      date: '2026-12-12',
      timeSlot: '2:00 PM - 10:00 PM',
      status: 'Pendiente',
      fee: 50.00,
    ),
    ReservationModel(
      id: 'res_02',
      spaceName: 'Área de Parrillera',
      unitNumber: 'Torre B - 201',
      reservedBy: 'luis@correo.com',
      date: '2026-11-28',
      timeSlot: '12:00 PM - 6:00 PM',
      status: 'Pendiente',
      fee: 20.00,
    ),
  ];

  void _approveReservation(ReservationModel res) {
    setState(() {
      _pendingReservations.removeWhere((r) => r.id == res.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reserva de ${res.spaceName} para ${res.unitNumber} APROBADA.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectReservation(ReservationModel res) {
    setState(() {
      _pendingReservations.removeWhere((r) => r.id == res.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Solicitud de ${res.unitNumber} RECHAZADA.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Aprobación de Áreas Comunes'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
      ),
      body: _pendingReservations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Colors.green.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay solicitudes de reserva pendientes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _pendingReservations.length,
              itemBuilder: (context, index) {
                final res = _pendingReservations[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              res.spaceName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: const Text(
                                'Pendiente',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Unidad Solicitante:', style: TextStyle(color: Colors.grey[700])),
                            Text(res.unitNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Fecha y Hora:', style: TextStyle(color: Colors.grey[700])),
                            Text('${res.date} (${res.timeSlot})', style: const TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tarifa / Depósito:', style: TextStyle(color: Colors.grey[700])),
                            Text(
                              res.fee > 0 ? '\$${res.fee.toStringAsFixed(2)} USD' : 'Sin costo',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _rejectReservation(res),
                                icon: const Icon(Icons.close, color: Colors.red, size: 18),
                                label: const Text('Rechazar', style: TextStyle(color: Colors.red)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.red),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                            // Botón de Enviar reutilizable
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomButton(
                                text: 'Aprobar',
                                icon: Icons.check,
                                backgroundColor: Colors.green,
                                onPressed: () => _approveReservation(res),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}