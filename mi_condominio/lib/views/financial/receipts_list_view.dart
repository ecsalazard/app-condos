import 'package:flutter/material.dart';
import '../../models/receipt_model.dart';
import 'payment_report_view.dart';
import '../../widgets/custom_button.dart';

class ReceiptsListView extends StatelessWidget {
  final String unitNumber; // Ej: "Torre A - 402"

  const ReceiptsListView({super.key, required this.unitNumber});

  @override
  Widget build(BuildContext context) {
    // Lista de ejemplo (Mock data) simulando lo que vendría de tu base de datos o API
    final List<ReceiptModel> mockReceipts = [
      ReceiptModel(
        id: 'rec_001',
        unitNumber: unitNumber,
        period: 'Mayo 2026',
        amount: 85.50,
        status: 'Pendiente',
        dueDate: '2026-05-30',
      ),
      ReceiptModel(
        id: 'rec_002',
        unitNumber: unitNumber,
        period: 'Abril 2026',
        amount: 85.50,
        status: 'Pagado',
        dueDate: '2026-04-30',
        paymentReference: 'ZELLE-984723',
        paymentDate: '2026-04-25',
      ),
      ReceiptModel(
        id: 'rec_003',
        unitNumber: unitNumber,
        period: 'Marzo 2026',
        amount: 80.00,
        status: 'Pagado',
        dueDate: '2026-03-30',
        paymentReference: 'TRANSF-123456',
        paymentDate: '2026-03-22',
      ),
    ];

    // Separamos los recibos según su estatus
    final pendingReceipts = mockReceipts.where((r) => r.status == 'Pendiente' || r.status == 'En Verificación').toList();
    final paidReceipts = mockReceipts.where((r) => r.status == 'Pagado').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Recibos - $unitNumber'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.receipt_long), text: 'Pendientes'),
              Tab(icon: Icon(Icons.verified), text: 'Historial Pagados'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pestaña 1: Recibos Pendientes
            _ReceiptsList(
              receipts: pendingReceipts,
              isPendingTab: true,
            ),
            // Pestaña 2: Historial de Pagos
            _ReceiptsList(
              receipts: paidReceipts,
              isPendingTab: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptsList extends StatelessWidget {
  final List<ReceiptModel> receipts;
  final bool isPendingTab;

  const _ReceiptsList({required this.receipts, required this.isPendingTab});

  @override
  Widget build(BuildContext context) {
    if (receipts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPendingTab ? Icons.check_circle_outline : Icons.folder_open,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isPendingTab ? '¡Estás al día con tus pagos!' : 'No hay historial de pagos registrado',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: receipts.length,
      itemBuilder: (context, index) {
        final receipt = receipts[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
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
                      'Periodo: ${receipt.period}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _StatusBadge(status: receipt.status),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Monto a Pagar:', style: TextStyle(color: Colors.grey)),
                    Text(
                      '\$${receipt.amount.toStringAsFixed(2)} USD',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                if (receipt.dueDate != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Fecha límite:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(receipt.dueDate!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
                if (receipt.paymentReference != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Referencia:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(receipt.paymentReference!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                CustomButton(
                  text: isPendingTab ? 'Reportar Pago de esta Cuota' : 'Ver Comprobante',
                  icon: isPendingTab ? Icons.payment : Icons.visibility,
                  backgroundColor: isPendingTab ? Colors.green : Colors.indigo.shade50,
                  textColor: isPendingTab ? Colors.white : Colors.indigo,
                  onPressed: () {
                    if (isPendingTab) {
                      // Navegar a la pantalla de reporte pasando los datos del recibo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentReportView(
                            receiptId: receipt.id,
                            period: receipt.period,
                            amountToPay: receipt.amount,
                          ),
                        ),
                      );
                    } else {
                      // Acción para ver el comprobante o detalles
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Viendo comprobante de ${receipt.period}')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (status == 'Pagado') {
      color = Colors.green;
    } else if (status == 'En Verificación') {
      color = Colors.orange;
    } else {
      color = Colors.red;
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