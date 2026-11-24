import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/status_badge.dart';

// Modelo simulado para una visita o autorización
class VisitorEntryModel {
  final String id;
  final String visitorName;
  final String visitorId;
  final String unitNumber; // Apartamento que autoriza
  final String visitType;
  final String? licensePlate;
  String status; // 'Esperado', 'Ingresó', 'Salió', 'Denegado'
  final String entryTime;

  VisitorEntryModel({
    required this.id,
    required this.visitorName,
    required this.visitorId,
    required this.unitNumber,
    required this.visitType,
    this.licensePlate,
    required this.status,
    required this.entryTime,
  });
}

class VisitorLogView extends StatefulWidget {
  const VisitorLogView({super.key});

  @override
  State<VisitorLogView> createState() => _VisitorLogViewState();
}

class _VisitorLogViewState extends State<VisitorLogView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Lista simulada de visitas autorizadas por residentes (esperando ingreso) y el historial de garita
  final List<VisitorEntryModel> _visitors = [
    VisitorEntryModel(
      id: 'vis_01',
      visitorName: 'Carlos Mendoza',
      visitorId: 'V-15489623',
      unitNumber: 'Torre A - 402',
      visitType: 'Visita Social / Familiar',
      licensePlate: 'ABC-123',
      status: 'Esperado',
      entryTime: 'Pendiente de llegada',
    ),
    VisitorEntryModel(
      id: 'vis_02',
      visitorName: 'Técnico de Aire Acondicionado',
      visitorId: 'V-9876543',
      unitNumber: 'Torre B - 102',
      visitType: 'Servicio Técnico',
      licensePlate: null,
      status: 'Esperado',
      entryTime: 'Pendiente de llegada',
    ),
    VisitorEntryModel(
      id: 'vis_03',
      visitorName: 'Delivery - ¡Ya Voy!',
      visitorId: 'Moto Express',
      unitNumber: 'Torre A - 201',
      visitType: 'Delivery',
      licensePlate: 'M-XYZ99',
      status: 'Ingresó',
      entryTime: '10:45 AM',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateStatus(String id, String newStatus) {
    setState(() {
      final index = _visitors.indexWhere((v) => v.id == id);
      if (index != -1) {
        _visitors[index].status = newStatus;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Estado actualizado a: $newStatus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtramos las listas según el estado
    final expectedVisitors = _visitors.where((v) => v.status == 'Esperado').toList();
    final activeLogs = _visitors.where((v) => v.status != 'Esperado').toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Garita de Vigilancia - Control de Acceso'),
        backgroundColor: Colors.blueGrey.shade900,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.orange,
          tabs: [
            Tab(
              icon: const Icon(Icons.qr_code_scanner),
              text: 'Esperados (${expectedVisitors.length})',
            ),
            const Tab(
              icon: const Icon(Icons.history),
              text: 'Historial en Condominio',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // PESTAÑA 1: Visitas Pre-autorizadas por residentes esperando ingreso
          _buildVisitorList(expectedVisitors, isExpectedTab: true),

          // PESTAÑA 2: Historial de accesos activos e ingresados
          _buildVisitorList(activeLogs, isExpectedTab: false),
        ],
      ),
    );
  }

  Widget _buildVisitorList(List<VisitorEntryModel> list, {required bool isExpectedTab}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isExpectedTab ? Icons.check_circle_outline : Icons.list_alt,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isExpectedTab
                  ? 'No hay visitas esperadas en este momento'
                  : 'No hay registros en el historial reciente',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final visitor = list[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      visitor.visitorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    StatusBadge(status: visitor.status),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Destino / Unidad:', style: TextStyle(color: Colors.grey[700])),
                    Text(
                      visitor.unitNumber,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Documento:', style: TextStyle(color: Colors.grey[700])),
                    Text(visitor.visitorId),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Motivo:', style: TextStyle(color: Colors.grey[700])),
                    Text(visitor.visitType, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                if (visitor.licensePlate != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Placa Vehículo:', style: TextStyle(color: Colors.grey[700])),
                      Text(visitor.licensePlate!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
                const SizedBox(height: 16),

                // Botones de acción rápida para el guardia
                if (isExpectedTab)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _updateStatus(visitor.id, 'Denegado'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Denegar', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: 'Registrar Ingreso',
                          backgroundColor: Colors.green,
                          onPressed: () => _updateStatus(visitor.id, 'Ingresó'),
                        ),
                      ),
                    ],
                  )
                else if (visitor.status == 'Ingresó')
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: () => _updateStatus(visitor.id, 'Salió'),
                      icon: const Icon(Icons.exit_to_app, size: 16, color: Colors.orange),
                      label: const Text('Marcar Salida', style: TextStyle(color: Colors.orange)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }


}