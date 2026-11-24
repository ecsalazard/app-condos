import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class PaymentReportView extends StatefulWidget {
  final String receiptId;
  final String period;
  final double amountToPay;

  const PaymentReportView({
    super.key,
    required this.receiptId,
    required this.period,
    required this.amountToPay,
  });

  @override
  State<PaymentReportView> createState() => _PaymentReportViewState();
}

class _PaymentReportViewState extends State<PaymentReportView> {
  final _formKey = GlobalKey<FormState>();
  final _referenceController = TextEditingController();
  final _amountController = TextEditingController();
  
  String _selectedBank = 'Zelle / Transferencia Internacional';
  bool _isLoading = false;
  String? _selectedImageName; // Simula el nombre del archivo de comprobante adjunto

  final List<String> _banks = [
    'Zelle / Transferencia Internacional',
    'Banco Nacional (Cuenta Corriente)',
    'Pago Móvil / Transferencia Local',
    'Efectivo / Caja del Condominio',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-llenar el monto con lo que indica el recibo
    _amountController.text = widget.amountToPay.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitPaymentReport() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImageName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor adjunta la foto del comprobante de pago'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      // Simulación de envío al servidor (2 segundos)
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Pago reportado con éxito! En verificación por administración.'),
            backgroundColor: Colors.green,
          ),
        );

        // Regresar a la pantalla anterior
        Navigator.pop(context);
      });
    }
  }

  void _pickProofImage() {
    // Simulación de selección de archivo en Flutter Web/Mobile
    setState(() {
      _selectedImageName = 'comprobante_pago_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comprobante adjuntado: $_selectedImageName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Reportar Pago - ${widget.period}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Encabezado de información
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Monto del Recibo:',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                            ),
                            Text(
                              '\$${widget.amountToPay.toStringAsFixed(2)} USD',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Selector de Método / Banco
                      DropdownButtonFormField<String>(
                        value: _selectedBank,
                        decoration: InputDecoration(
                          labelText: 'Método / Banco Receptor',
                          prefixIcon: const Icon(Icons.account_balance_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _banks.map((String bank) {
                          return DropdownMenuItem<String>(
                            value: bank,
                            child: Text(bank, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => _selectedBank = newValue);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo de Referencia o Número de Operación
                      TextFormField(
                        controller: _referenceController,
                        decoration: InputDecoration(
                          labelText: 'Número de Referencia / Operación',
                          hintText: 'Ej: 984723 o ZELLE-ABC1234',
                          prefixIcon: const Icon(Icons.confirmation_number_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el número de referencia';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo de Monto Pagado
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Monto Pagado',
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa el monto pagado';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Ingresa un número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Sección de Carga de Comprobante
                      const Text(
                        'Comprobante de Pago',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _pickProofImage,
                        icon: const Icon(Icons.upload_file),
                        label: Text(_selectedImageName ?? 'Adjuntar foto o PDF del comprobante'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      if (_selectedImageName != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Archivo seleccionado: ${_selectedImageName!}',
                          style: const TextStyle(color: Colors.green, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 32),

                      // Botón de Enviar Reporte
                      CustomButton(
                        text: 'Enviar Reporte de Pago',
                        backgroundColor: Colors.green, // 👈 Mantiene tu color verde característico
                        isLoading: _isLoading,        // 👈 Controla automáticamente el estado de carga
                        onPressed: _submitPaymentReport, // <span>👈 Ejecuta tu función original</span>
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}