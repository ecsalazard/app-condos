import 'package:flutter/material.dart';
import '../../models/receipt_model.dart';
import '../../widgets/custom_button.dart';

class AdminLedgerView extends StatefulWidget {
  const AdminLedgerView({super.key});

  @override
  State<AdminLedgerView> createState() => _AdminLedgerViewState();
}

class _AdminLedgerViewState extends State<AdminLedgerView> {
  // Lista temporal simulando pagos que los residentes han reportado y esperan aprobación
  final List<ReceiptModel> _pendingVerificationReceipts = [
    ReceiptModel(
      id: 'rec_101',
      unitNumber: 'Torre A - 402',
      period: 'Mayo 2026',
      amount: 85.50,
      status: 'En Verificación',
      dueDate: '2026-05-30',
      paymentReference: 'ZELLE-984723',
      paymentDate: '2026-05-18',
      paymentProofUrl: 'comprobante_402.jpg',
    ),
    ReceiptModel(
      id: 'rec_102',
      unitNumber: 'Torre B - 103',
      period: 'Mayo 2026',
      amount: 110.00,
      status: 'En Verificación',
      dueDate: '2026-05-30',
      paymentReference: 'TRANSF-445566',
      paymentDate: '2026-05-17',
      paymentProofUrl: 'comprobante_103.pdf',
    ),
  ];

  void _approvePayment(ReceiptModel receipt) {
    setState(() {
      _pendingVerificationReceipts.removeWhere((r) => r.id == receipt.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pago de la unidad ${receipt.unitNumber} (${receipt.period}) APROBADO con éxito.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectPayment(ReceiptModel receipt) {
    // Aquí podrías abrir un diálogo para pedir el motivo del rechazo
    setState(() {
      _pendingVerificationReceipts.removeWhere((r) => r.id == receipt.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pago de la unidad ${receipt.unitNumber} RECHAZADO. Se notificó al residente.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showProofDetails(ReceiptModel receipt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Comprobante - ${receipt.unitNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Periodo: ${receipt.period}'),
            const SizedBox(height: 8),
            Text('Referencia: ${receipt.paymentReference}'),
            const SizedBox(height: 8),
            Text('Monto reportado: \$${receipt.amount.toStringAsFixed(2)} USD'),
            const SizedBox(height: 8),
            Text('Fecha de pago: ${receipt.paymentDate}'),
            const SizedBox(height: 16),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.insert_drive_file, size: 48, color: Colors.indigo),
                    SizedBox(height: 8),
                    Text('Vista previa del comprobante adjunto', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              _approvePayment(receipt);
            },
            icon: const Icon(Icons.check),
            label: const Text('Aprobar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Conciliación y Verificación de Pagos'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
      ),
      body: _pendingVerificationReceipts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Colors.green[400]),
                  const SizedBox(height: 16),
                  const Text(
                    '¡No hay pagos pendientes por verificar!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _pendingVerificationReceipts.length,
              itemBuilder: (context, index) {
                final receipt = _pendingVerificationReceipts[index];
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
                              receipt.unitNumber,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: const Text(
                                'En Verificación',
                                style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Periodo: ${receipt.period}', style: const TextStyle(fontWeight: FontWeight.w500)),
                            Text(
                              '\$${receipt.amount.toStringAsFixed(2)} USD',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Referencia: ${receipt.paymentReference}', style: TextStyle(color: Colors.grey[700])),
                            Text('Fecha: ${receipt.paymentDate}', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showProofDetails(receipt),
                                icon: const Icon(Icons.receipt_long, size: 16),
                                label: const Text('Ver Comprobante'),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _rejectPayment(receipt),
                              icon: const Icon(Icons.close, color: Colors.red),
                              tooltip: 'Rechazar pago',
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: CustomButton(
                                text: 'Aprobar',
                                icon: Icons.check,
                                backgroundColor: Colors.green,
                                onPressed: () => _approvePayment(receipt),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}