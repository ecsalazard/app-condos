import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'aprobada':
      case 'aprobado':
      case 'pagado':
      case 'ingresó':
      case 'al día':
        color = Colors.green;
        break;
      case 'pendiente':
      case 'esperado':
        color = Colors.orange;
        break;
      case 'rechazada':
      case 'rechazado':
      case 'denegado':
      case 'vencido':
      case 'cancelada':
        color = Colors.red;
        break;
      default:
        color = Colors.blueGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}