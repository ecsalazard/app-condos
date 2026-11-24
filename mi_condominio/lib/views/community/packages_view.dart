import 'package:flutter/material.dart';

class PackageModel {
  final String id;
  final String trackingNumber;
  final String courier;
  final String receivedDate;
  String status; // 'En Garita', 'Retirado'
  final String receivedByGuard;

  PackageModel({
    required this.id,
    required this.trackingNumber,
    required this.courier,
    required this.receivedDate,
    required this.status,
    required this.receivedByGuard,
  });
}

class PackagesView extends StatefulWidget {
  const PackagesView({super.key});

  @override
  State<PackagesView> createState() => _PackagesViewState();
}

class _PackagesViewState extends State<PackagesView> {
  final List<PackageModel> _packages = [
    PackageModel(
      id: 'pkg_01',
      trackingNumber: 'AMZ-998234',
      courier: 'Amazon / Delivery',
      receivedDate: 'Hoy, 2:15 PM',
      status: 'En Garita',
      receivedByGuard: 'Garita Principal',
    ),
    PackageModel(
      id: 'pkg_02',
      trackingNumber: 'DHL-445120',
      courier: 'DHL Express',
      receivedDate: 'Ayer, 10:30 AM',
      status: 'Retirado',
      receivedByGuard: 'Garita Principal',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Buzón de Paquetería'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _packages.length,
        itemBuilder: (context, index) {
          final pkg = _packages[index];
          bool isPending = pkg.status == 'En Garita';
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_shipping_outlined, color: Colors.indigo.shade800),
                          const SizedBox(width: 8),
                          Text(
                            pkg.courier,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPending ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isPending ? Colors.orange : Colors.green),
                        ),
                        child: Text(
                          pkg.status,
                          style: TextStyle(
                            color: isPending ? Colors.orange.shade800 : Colors.green.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Text('Guía / Tracking: ${pkg.trackingNumber}', style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 4),
                  Text('Recibido: ${pkg.receivedDate}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('Ubicación actual: Resguardado en ${pkg.receivedByGuard}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}