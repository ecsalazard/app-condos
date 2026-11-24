import 'package:flutter/material.dart';
import '../../models/unit_model.dart';
import '../../widgets/custom_button.dart';

class IssueReceiptsView extends StatefulWidget {
  const IssueReceiptsView({super.key});

  @override
  State<IssueReceiptsView> createState() => _IssueReceiptsViewState();
}

class _IssueReceiptsViewState extends State<IssueReceiptsView> {
  final _formKey = GlobalKey<FormState>();
  final _periodController = TextEditingController(text: 'Junio 2026');
  final _totalExpenseController = TextEditingController();
  final _dueDateController = TextEditingController(text: '2026-06-30');

  double _totalMonthlyExpense = 0.0;
  bool _isGenerating = false;

  // Lista simulada de unidades del condominio (usando UnitModel)
  // La suma de los coeficientes de todo el edificio siempre debe dar 1.0 (100%)
  final List<UnitModel> _units = [
    UnitModel(
      id: 'u_01',
      towerName: 'Torre A',
      unitNumber: '101',
      ownerName: 'Carlos Pérez',
      ownerEmail: 'carlos@correo.com',
      participationCoefficient: 0.25, // 25%
      status: 'Al día',
    ),
    UnitModel(
      id: 'u_02',
      towerName: 'Torre A',
      unitNumber: '102',
      ownerName: 'María González',
      ownerEmail: 'maria@correo.com',
      participationCoefficient: 0.25, // 25%
      status: 'Al día',
    ),
    UnitModel(
      id: 'u_03',
      towerName: 'Torre B',
      unitNumber: '201',
      ownerName: 'Luis Rodríguez',
      ownerEmail: 'luis@correo.com',
      participationCoefficient: 0.30, // 30%
      status: 'Moroso',
    ),
    UnitModel(
      id: 'u_04',
      towerName: 'Torre B',
      unitNumber: 'PH-1',
      ownerName: 'Ana Martínez',
      ownerEmail: 'ana@correo.com',
      participationCoefficient: 0.20, // 20%
      status: 'Al día',
    ),
  ];

  @override
  void dispose() {
    _periodController.dispose();
    _totalExpenseController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  void _generateReceipts() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isGenerating = true);

      // Simulación de generación y envío de recibos en base de datos
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _isGenerating = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡${_units.length} recibos emitidos para ${_periodController.text}!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Emisión de Recibos de Cobro'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tarjeta de Configuración del Mes
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Datos de Facturación Mensual',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _periodController,
                                  decoration: InputDecoration(
                                    labelText: 'Periodo a Facturar',
                                    hintText: 'Ej: Junio 2026',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (v) =>
                                      v!.isEmpty ? 'Requerido' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _dueDateController,
                                  decoration: InputDecoration(
                                    labelText: 'Fecha Límite de Pago',
                                    hintText: 'AAAA-MM-DD',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (v) =>
                                      v!.isEmpty ? 'Requerido' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _totalExpenseController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Gasto Común Total del Mes (USD)',
                              hintText: 'Ej: 1500.00',
                              prefixIcon: const Icon(Icons.calculate_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _totalMonthlyExpense =
                                    double.tryParse(value) ?? 0.0;
                              });
                            },
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Ingresa el monto total de gastos';
                              }
                              if ((double.tryParse(v) ?? 0) <= 0) {
                                return 'El monto debe ser mayor a 0';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Título de Vista Previa
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vista Previa por Unidad',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_units.length} unidades',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Lista dinámica que calcula cada cuota en tiempo real
                  Expanded(
                    child: ListView.builder(
                      itemCount: _units.length,
                      itemBuilder: (context, index) {
                        final unit = _units[index];
                        final unitQuota =
                            _totalMonthlyExpense * unit.participationCoefficient;
                        final percentage =
                            (unit.participationCoefficient * 100).toStringAsFixed(1);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.teal.shade50,
                              child: const Icon(
                                Icons.apartment,
                                color: Colors.teal,
                              ),
                            ),
                            title: Text(
                              '${unit.towerName} - ${unit.unitNumber}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${unit.ownerName} • Coeficiente: $percentage%',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              '\$${unitQuota.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón para Emitir los Recibos
                  CustomButton(
                     text: 'Emitir y Publicar Recibos del Mes',
                     icon: Icons.send_rounded,
                     backgroundColor: Colors.teal,
                     isLoading: _isGenerating,
                     onPressed: _generateReceipts,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}