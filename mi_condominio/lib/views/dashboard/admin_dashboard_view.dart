import 'package:flutter/material.dart';
import '../auth/login_view.dart';
import '../../views/financial/admin_ledger_view.dart';
import '../financial/issue_receipts_view.dart';
import '../financial/units_management_view.dart';
import '../security/visitor_log_view.dart';
import '../communication/announcements_view.dart';
import '../spaces/admin_reservations_view.dart';
import '../../widgets/custom_button.dart'; // 👈 Importamos el botón reutilizable

class AdminDashboardView extends StatelessWidget {
  final String userEmail;

  const AdminDashboardView({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Panel de Administración'),
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
            // Tarjeta de Perfil del Administrador compacta
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
                    child: Icon(Icons.admin_panel_settings, size: 28, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Administración / Junta de Condominio',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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

            // Resumen de Indicadores Financieros (KPIs)
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    title: 'Recaudación Mes',
                    value: '84%',
                    subtitle: '\$4,200 / \$5,000',
                    color: Colors.green.shade700,
                    icon: Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KpiCard(
                    title: 'Morosidad Total',
                    value: '\$800',
                    subtitle: '4 unidades vencidas',
                    color: Colors.red.shade700,
                    icon: Icons.warning_amber_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Gestión del Condominio',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 12),

            // Cuadrícula compacta usando CustomButton
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.3, // 👈 Proporción compacta para botones limpios
              children: [
                CustomButton(
                  text: 'Control Unidades',
                  icon: Icons.apartment,
                  backgroundColor: Colors.blueGrey,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UnitsManagementView(),
                      ),
                    );
                  },
                ),
                CustomButton(
                  text: 'Emitir Recibos',
                  icon: Icons.request_quote,
                  backgroundColor: Colors.teal,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IssueReceiptsView(),
                      ),
                    );
                  },
                ),
                CustomButton(
                  text: 'Conciliación',
                  icon: Icons.fact_check,
                  backgroundColor: Colors.deepOrange,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminLedgerView(),
                      ),
                    );
                  },
                ),
                CustomButton(
                  text: 'Unidades Morosas',
                  icon: Icons.money_off,
                  backgroundColor: Colors.redAccent,
                  height: 44,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Listado de morosos y restricciones.')),
                    );
                  },
                ),
                CustomButton(
                  text: 'Proveedores y Gastos',
                  icon: Icons.receipt_long,
                  backgroundColor: Colors.purple.shade700,
                  height: 44,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Control de facturas y servicios operativos.')),
                    );
                  },
                ),
                CustomButton(
                  text: 'Helpdesk Averías',
                  icon: Icons.handyman,
                  backgroundColor: Colors.blue.shade700,
                  height: 44,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bandeja de reportes de mantenimiento.')),
                    );
                  },
                ),
                CustomButton(
                  text: 'Aprobar Reservas',
                  icon: Icons.event_available,
                  backgroundColor: Colors.amber.shade800,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminReservationsView(),
                      ),
                    );
                  },
                ),
                CustomButton(
                  text: 'Publicar Avisos',
                  icon: Icons.announcement,
                  backgroundColor: Colors.indigo,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnnouncementsView(isAdmin: true),
                      ),
                    );
                  },
                ),
                CustomButton(
                  text: 'Portería y Accesos',
                  icon: Icons.security,
                  backgroundColor: Colors.brown,
                  height: 44,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VisitorLogView(),
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

// Widget auxiliar para los KPIs Financieros superiores
class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Icon(icon, size: 16, color: color),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}