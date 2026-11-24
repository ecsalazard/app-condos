import 'package:flutter/material.dart';
import '../../models/reservation_model.dart';
import '../../widgets/custom_button.dart';


class BookingFormView extends StatefulWidget {
  final String unitNumber;
  final String userName;

  const BookingFormView({
    super.key,
    required this.unitNumber,
    required this.userName,
  });

  @override
  State<BookingFormView> createState() => _BookingFormViewState();
}

class _BookingFormViewState extends State<BookingFormView> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

  String _selectedSpace = 'Salón de Fiestas';
  String _selectedTimeSlot = '2:00 PM - 10:00 PM';

  // Mapa de espacios y sus tarifas asociadas
  final Map<String, double> _spacesCatalog = {
    'Salón de Fiestas': 50.00,
    'Área de Parrillera': 20.00,
    'Cancha Múltiple': 0.00,
    'Área de Piscina (Evento)': 35.00,
  };

  final List<String> _timeSlots = [
    '9:00 AM - 2:00 PM',
    '12:00 PM - 6:00 PM',
    '2:00 PM - 10:00 PM',
    'Todo el día (9:00 AM - 10:00 PM)',
  ];

  @override
  void initState() {
    super.initState();
    // Fecha inicial sugerida (2 días a futuro)
    final initialDate = DateTime.now().add(const Duration(days: 2));
    _dateController.text =
        '${initialDate.year}-${initialDate.month.toString().padLeft(2, '0')}-${initialDate.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 2)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      final currentFee = _spacesCatalog[_selectedSpace] ?? 0.0;
      
      final newReservation = ReservationModel(
        id: 'res_${DateTime.now().millisecondsSinceEpoch}',
        spaceName: _selectedSpace,
        unitNumber: widget.unitNumber,
        reservedBy: widget.userName,
        date: _dateController.text,
        timeSlot: _selectedTimeSlot,
        status: 'Pendiente',
        fee: currentFee,
      );

      // Retornamos la reserva creada hacia la pantalla anterior
      Navigator.pop(context, newReservation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFee = _spacesCatalog[_selectedSpace] ?? 0.0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Solicitar Reserva de Espacio'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Nueva Solicitud',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Unidad: ${widget.unitNumber}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 24),

                      // Selector de Espacio
                      DropdownButtonFormField<String>(
                        value: _selectedSpace,
                        decoration: InputDecoration(
                          labelText: 'Área Común',
                          prefixIcon: const Icon(Icons.place_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _spacesCatalog.keys.map((String space) {
                          return DropdownMenuItem<String>(
                            value: space,
                            child: Text(space),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedSpace = val);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Selector de Fecha
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          labelText: 'Fecha del Evento',
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v!.isEmpty ? 'Selecciona una fecha' : null,
                      ),
                      const SizedBox(height: 16),

                      // Selector de Horario
                      DropdownButtonFormField<String>(
                        value: _selectedTimeSlot,
                        decoration: InputDecoration(
                          labelText: 'Bloque Horario',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _timeSlots.map((String slot) {
                          return DropdownMenuItem<String>(
                            value: slot,
                            child: Text(slot, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedTimeSlot = val);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Resumen de Tarifa
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.indigo.shade100),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tarifa / Depósito:', style: TextStyle(fontWeight: FontWeight.w500)),
                            Text(
                              currentFee > 0 ? '\$${currentFee.toStringAsFixed(2)} USD' : 'Gratuito',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Botón de Enviar reutilizable
                      CustomButton(
                        text: 'Enviar Solicitud',
                        icon: Icons.event_available,
                        backgroundColor: Colors.orange.shade800,
                        onPressed: _submitBooking, // 👈 Conserva tu función original aquí
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}