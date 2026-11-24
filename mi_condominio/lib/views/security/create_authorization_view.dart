import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class CreateAuthorizationView extends StatefulWidget {
  final String unitNumber; // Apartamento que emite la autorización

  const CreateAuthorizationView({super.key, required this.unitNumber});

  @override
  State<CreateAuthorizationView> createState() => _CreateAuthorizationViewState();
}

class _CreateAuthorizationViewState extends State<CreateAuthorizationView> {
  final _formKey = GlobalKey<FormState>();
  final _visitorNameController = TextEditingController();
  final _visitorIdController = TextEditingController();
  final _plateController = TextEditingController();
  
  String _selectedVisitType = 'Visita Social / Familiar';
  bool _isLoading = false;

  final List<String> _visitTypes = [
    'Visita Social / Familiar',
    'Servicio Técnico / Reparación',
    'Delivery / Encomienda',
    'Familiar Frecuente',
  ];

  @override
  void dispose() {
    _visitorNameController.dispose();
    _visitorIdController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _submitAuthorization() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulación de guardado en base de datos o servidor
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Autorización creada con éxito! Notificado a portería.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context); // Regresar al panel anterior
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Autorizar Visita - ${widget.unitNumber}'),
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
                        'Generar Pase de Acceso',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Registra los datos de tu invitado para agilizar su ingreso en la garita.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 24),

                      // Tipo de Visita
                      DropdownButtonFormField<String>(
                        value: _selectedVisitType,
                        decoration: InputDecoration(
                          labelText: 'Motivo de la Visita',
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _visitTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedVisitType = val);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Nombre del Visitante
                      TextFormField(
                        controller: _visitorNameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre Completo del Visitante',
                          hintText: 'Ej: Juan Pérez',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v!.isEmpty ? 'Por favor ingresa el nombre' : null,
                      ),
                      const SizedBox(height: 16),

                      // Cédula o Documento
                      TextFormField(
                        controller: _visitorIdController,
                        decoration: InputDecoration(
                          labelText: 'Cédula o Documento de Identidad',
                          hintText: 'Ej: V-12345678',
                          prefixIcon: const Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v!.isEmpty ? 'Por favor ingresa el documento' : null,
                      ),
                      const SizedBox(height: 16),

                      // Placa del Vehículo
                      TextFormField(
                        controller: _plateController,
                        decoration: InputDecoration(
                          labelText: 'Placa del Vehículo (Opcional)',
                          hintText: 'Ej: ABC-123',
                          prefixIcon: const Icon(Icons.directions_car_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Botón de Enviar
                      CustomButton(
                        text: 'Emitir Autorización',
                        icon: Icons.check_circle_outline,
                        backgroundColor: Colors.indigo.shade900,
                        isLoading: _isLoading,
                        onPressed: _submitAuthorization,
                      ),
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