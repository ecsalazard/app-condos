import 'package:flutter/material.dart';
import '../../models/unit_model.dart';
import '../../widgets/custom_button.dart';

class UnitsManagementView extends StatefulWidget {
  const UnitsManagementView({super.key});

  @override
  State<UnitsManagementView> createState() => _UnitsManagementViewState();
}

class _UnitsManagementViewState extends State<UnitsManagementView> {
  // Lista de ejemplo simulando las unidades registradas en la base de datos
  final List<UnitModel> _units = [
    UnitModel(
      id: 'u_01',
      towerName: 'Torre A',
      unitNumber: '101',
      ownerName: 'Carlos Pérez',
      ownerEmail: 'carlos@correo.com',
      participationCoefficient: 0.25,
      status: 'Al día',
    ),
    UnitModel(
      id: 'u_02',
      towerName: 'Torre A',
      unitNumber: '102',
      ownerName: 'María González',
      ownerEmail: 'maria@correo.com',
      participationCoefficient: 0.25,
      status: 'Al día',
    ),
    UnitModel(
      id: 'u_03',
      towerName: 'Torre B',
      unitNumber: '201',
      ownerName: 'Luis Rodríguez',
      ownerEmail: 'luis@correo.com',
      participationCoefficient: 0.30,
      status: 'Moroso',
    ),
    UnitModel(
      id: 'u_04',
      towerName: 'Torre B',
      unitNumber: 'PH-1',
      ownerName: 'Ana Martínez',
      ownerEmail: 'ana@correo.com',
      participationCoefficient: 0.20,
      status: 'Al día',
    ),
  ];

  void _showAddUnitModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _NewUnitForm(
        onUnitAdded: (newUnit) {
          setState(() {
            _units.add(newUnit);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unidad registrada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Control de Unidades y Propietarios'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen superior
            Card(
              elevation: 0,
              color: Colors.indigo.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MetricItem(
                      label: 'Total Unidades',
                      value: '${_units.length}',
                    ),
                    _MetricItem(
                      label: 'Al Día',
                      value: '${_units.where((u) => u.status == 'Al día').length}',
                      color: Colors.green,
                    ),
                    _MetricItem(
                      label: 'Morosos',
                      value: '${_units.where((u) => u.status == 'Moroso').length}',
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Listado de Inmuebles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Lista de unidades
            Expanded(
              child: ListView.builder(
                itemCount: _units.length,
                itemBuilder: (context, index) {
                  final unit = _units[index];
                  final isMoroso = unit.status == 'Moroso';

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: isMoroso
                            ? Colors.red.shade50
                            : Colors.indigo.shade50,
                        child: Icon(
                          Icons.apartment,
                          color: isMoroso ? Colors.red : Colors.indigo,
                        ),
                      ),
                      title: Text(
                        '${unit.towerName} - Unidad ${unit.unitNumber}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Propietario: ${unit.ownerName}'),
                          Text(
                            'Coeficiente: ${(unit.participationCoefficient * 100).toStringAsFixed(1)}% • ${unit.ownerEmail}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isMoroso
                              ? Colors.red.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isMoroso ? Colors.red : Colors.green,
                          ),
                        ),
                        child: Text(
                          unit.status,
                          style: TextStyle(
                            color: isMoroso ? Colors.red : Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
        onPressed: _showAddUnitModal,
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Unidad'),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _MetricItem({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.indigo.shade900,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }
}

// Formulario flotante para agregar una unidad nueva
class _NewUnitForm extends StatefulWidget {
  final Function(UnitModel) onUnitAdded;

  const _NewUnitForm({required this.onUnitAdded});

  @override
  State<_NewUnitForm> createState() => _NewUnitFormState();
}

class _NewUnitFormState extends State<_NewUnitForm> {
  final _formKey = GlobalKey<FormState>();
  final _towerController = TextEditingController();
  final _unitController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _coefficientController = TextEditingController();

  @override
  void dispose() {
    _towerController.dispose();
    _unitController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _coefficientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Registrar Nueva Unidad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _towerController,
                      decoration: InputDecoration(
                        labelText: 'Torre / Edificio',
                        hintText: 'Ej: Torre A',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: InputDecoration(
                        labelText: 'Número de Unidad',
                        hintText: 'Ej: 402',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Propietario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _coefficientController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Coeficiente (Ej: 0.025 para 2.5%)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (double.tryParse(v) == null) return 'Ingresa un decimal válido';
                  return null;
                },
              ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Guardar Unidad',
                  backgroundColor: Colors.indigo.shade900,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newUnit = UnitModel(
                        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
                        towerName: _towerController.text,
                        unitNumber: _unitController.text,
                        ownerName: _nameController.text,
                        ownerEmail: _emailController.text,
                        participationCoefficient:
                            double.parse(_coefficientController.text),
                        status: 'Al día',
                      );
                      widget.onUnitAdded(newUnit);
                      Navigator.pop(context);
                    }
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}