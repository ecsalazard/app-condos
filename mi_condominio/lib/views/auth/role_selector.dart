import 'package:flutter/material.dart';
import '../dashboard/resident_dashboard_view.dart';
import '../dashboard/admin_dashboard_view.dart';
import '../security/visitor_log_view.dart'; // ✨ AGREGADO: Importamos la garita
import 'login_view.dart';

class RoleSelectorView extends StatelessWidget {
  final String userEmail;
  final List<String> availableRoles; // Ej: ['Residente', 'Administrador / Junta', 'Vigilancia / Garita']

  const RoleSelectorView({
    super.key,
    required this.userEmail,
    required this.availableRoles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Seleccionar Perfil de Acceso'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.supervised_user_circle_rounded,
                  size: 64,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 16),
                const Text(
                  '¿Cómo deseas ingresar hoy?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userEmail,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 32),

                // Generamos dinámicamente las opciones según los roles que tenga el usuario
                ...availableRoles.map((role) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _RoleCard(
                      roleName: role,
                      onTap: () => _navigateToRole(context, role),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✨ ACTUALIZADO: Ahora maneja los 3 roles y usa Navigator.push para facilitar las pruebas
  void _navigateToRole(BuildContext context, String role) {
    if (role.contains('Administrador') || role.contains('Junta')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminDashboardView(userEmail: userEmail),
        ),
      );
    } else if (role.contains('Vigilancia') || role.contains('Garita')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VisitorLogView(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResidentDashboardView(userEmail: userEmail),
        ),
      );
    }
  }
}

class _RoleCard extends StatelessWidget {
  final String roleName;
  final VoidCallback onTap;

  const _RoleCard({required this.roleName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // ✨ ACTUALIZADO: Detectamos los 3 tipos de rol
    final bool isAdmin = roleName.contains('Administrador') || roleName.contains('Junta');
    final bool isSecurity = roleName.contains('Vigilancia') || roleName.contains('Garita');

    // Definimos estilo visual según el rol
    Color bgColor = Colors.indigo.shade50;
    Color iconColor = Colors.indigo;
    IconData iconData = Icons.person;
    String subtitle = 'Acceso a tus pagos, reservas y avisos';

    if (isAdmin) {
      bgColor = Colors.indigo.shade900;
      iconColor = Colors.white;
      iconData = Icons.admin_panel_settings;
      subtitle = 'Acceso a finanzas, recibos y gestión';
    } else if (isSecurity) {
      bgColor = Colors.blueGrey.shade800;
      iconColor = Colors.white;
      iconData = Icons.security;
      subtitle = 'Control de acceso, visitas y garita';
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: bgColor,
                child: Icon(iconData, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roleName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}