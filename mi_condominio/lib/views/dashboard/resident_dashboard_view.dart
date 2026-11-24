import 'package:flutter/material.dart';
import '../auth/login_view.dart';
import '../financial/receipts_list_view.dart';
import '../financial/payment_report_view.dart';
import '../communication/announcements_view.dart';
import '../spaces/spaces_list_view.dart';
import '../security/create_authorization_view.dart';
import '../community/packages_view.dart';
import '../community/polls_view.dart';
import '../../widgets/custom_button.dart'; // 👈 Importamos el botón reutilizable

class ResidentDashboardView extends StatelessWidget {
  final String userEmail;

  const ResidentDashboardView({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Panel de Residente'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de Bienvenida e Información de la Unidad
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade900, Colors.indigo.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.home, size: 28, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Torre A - Apartamento 402',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Gestión y Servicios',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 12),

            // Cuadrícula compacta usando CustomButton
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.3, // 👈 Proporción ideal para botones compactos y limpios
              children: [
                // 1. Mis Recibos y Estado de Cuenta
                CustomButton(
                  text: 'Mis Recibos',
                  icon: Icons.receipt_long_outlined,
                  backgroundColor: Colors.indigo,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReceiptsListView(unitNumber: 'Torre A - 402'),
                      ),
                    );
                  },
                ),

                // 2. Reportar Pago Realizado
                CustomButton(
                  text: 'Reportar Pago',
                  icon: Icons.payment_outlined,
                  backgroundColor: Colors.green.shade700,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentReportView(
                          receiptId: 'rec_general',
                          period: 'Pago General / Abono',
                          amountToPay: 0.0,
                        ),
                      ),
                    );
                  },
                ),

                // 3. Reservar Áreas Comunes
                CustomButton(
                  text: 'Reservar Áreas',
                  icon: Icons.event_available_outlined,
                  backgroundColor: Colors.orange.shade800,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpacesListView(
                          unitNumber: 'Torre A - 402',
                          userName: userEmail,
                        ),
                      ),
                    );
                  },
                ),

                // 4. Autorizar Visitas (Garita)
                CustomButton(
                  text: 'Autorizar Visita',
                  icon: Icons.qr_code_scanner_rounded,
                  backgroundColor: Colors.teal.shade700,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAuthorizationView(
                          unitNumber: 'Torre A - 402',
                        ),
                      ),
                    );
                  },
                ),

                // 5. Avisos y Comunicados
                CustomButton(
                  text: 'Avisos Edificio',
                  icon: Icons.campaign_outlined,
                  backgroundColor: Colors.purple.shade700,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnnouncementsView(isAdmin: false),
                      ),
                    );
                  },
                ),

                // 6. Reportes de Mantenimiento / Averías
                CustomButton(
                  text: 'Reportar Avería',
                  icon: Icons.build_outlined,
                  backgroundColor: Colors.blueGrey,
                  height: 44,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Módulo de reporte de averías próximamente.')),
                    );
                  },
                ),
                
                // 7. Buzón de Paquetería
                CustomButton(
                  text: 'Paquetería',
                  icon: Icons.local_shipping_outlined,
                  backgroundColor: Colors.deepPurple,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PackagesView(),
                      ),
                    );
                  },
                ),

                // 8. Votaciones y Asambleas
                CustomButton(
                  text: 'Votaciones',
                  icon: Icons.how_to_vote_outlined,
                  backgroundColor: Colors.teal.shade800,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PollsView(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}