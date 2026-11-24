import 'package:flutter/material.dart';
import '../../models/reservation_model.dart';
import 'booking_form_view.dart'; 
import '../../widgets/status_badge.dart'; 



class SpacesListView extends StatefulWidget {
  final String unitNumber;
  final String userName;

  const SpacesListView({
    super.key,
    required this.unitNumber,
    required this.userName,
  });

  @override
  State<SpacesListView> createState() => _SpacesListViewState();
}

class _SpacesListViewState extends State<SpacesListView> {
  // Lista simulada de reservas existentes de la unidad
  final List<ReservationModel> _reservations = [
    ReservationModel(
      id: 'res_01',
      spaceName: 'Salón de Fiestas',
      unitNumber: 'Torre A - 402',
      reservedBy: 'Residente',
      date: '2026-12-12',
      timeSlot: '2:00 PM - 10:00 PM',
      status: 'Aprobada',
      fee: 50.00,
    ),
    ReservationModel(
      id: 'res_02',
      spaceName: 'Área de Parrillera',
      unitNumber: 'Torre A - 402',
      reservedBy: 'Residente',
      date: '2026-11-28',
      timeSlot: '12:00 PM - 6:00 PM',
      status: 'Pendiente',
      fee: 20.00,
    ),
  ];

  // 👇 Reemplaza el método antiguo por este:
  void _openBookingForm() async {
    final ReservationModel? newReservation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingFormView(
          unitNumber: widget.unitNumber,
          userName: widget.userName,
        ),
      ),
    );

    // Si el usuario completó la reserva y regresó el objeto, lo agregamos a la lista
    if (newReservation != null) {
      setState(() {
        _reservations.insert(0, newReservation);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud de reserva enviada con éxito.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _cancelReservation(String id) {
    setState(() {
      final index = _reservations.indexWhere((r) => r.id == id);
      if (index != -1) {
        final old = _reservations[index];
        _reservations[index] = ReservationModel(
          id: old.id,
          spaceName: old.spaceName,
          unitNumber: old.unitNumber,
          reservedBy: old.reservedBy,
          date: old.date,
          timeSlot: old.timeSlot,
          status: 'Cancelada',
          fee: old.fee,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reserva cancelada.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Reserva de Áreas Comunes'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner informativo
            Card(
              color: Colors.orange.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.orange.shade200),
              ),
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Las reservas están sujetas a disponibilidad y aprobación de la Junta de Condominio.',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Mis Solicitudes y Reservas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Lista de reservas
            Expanded(
              child: _reservations.isEmpty
                  ? Center(
                      child: Text(
                        'Aún no tienes reservas registradas.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _reservations.length,
                      itemBuilder: (context, index) {
                        final res = _reservations[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          _getSpaceIcon(res.spaceName),
                                          color: Colors.indigo,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          res.spaceName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    StatusBadge(status: res.status),
                                  ],
                                ),
                                const Divider(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Fecha: ${res.date}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                      res.fee > 0
                                          ? 'Tarifa: \$${res.fee.toStringAsFixed(2)}'
                                          : 'Sin costo',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Horario: ${res.timeSlot}',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13),
                                ),
                                if (res.status == 'Pendiente' ||
                                    res.status == 'Aprobada') ...[
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () =>
                                          _cancelReservation(res.id),
                                      icon: const Icon(Icons.cancel_outlined,
                                          size: 16, color: Colors.red),
                                      label: const Text(
                                        'Cancelar Reserva',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openBookingForm, // 👈 Apunta al nuevo método
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.event_available),
        label: const Text('Nueva Reserva'),
      ),
    );
  }

  IconData _getSpaceIcon(String spaceName) {
    if (spaceName.contains('Fiestas')) return Icons.celebration;
    if (spaceName.contains('Parrillera')) return Icons.outdoor_grill;
    if (spaceName.contains('Cancha')) return Icons.sports_tennis;
    return Icons.place;
  }
}





