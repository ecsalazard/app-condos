import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class PollModel {
  final String id;
  final String title;
  final String description;
  final String endDate;
  bool hasVoted;
  String? selectedOption;

  PollModel({
    required this.id,
    required this.title,
    required this.description,
    required this.endDate,
    required this.hasVoted,
    this.selectedOption,
  });
}

class PollsView extends StatefulWidget {
  const PollsView({super.key});

  @override
  State<PollsView> createState() => _PollsViewState();
}

class _PollsViewState extends State<PollsView> {
  final List<PollModel> _polls = [
    PollModel(
      id: 'poll_01',
      title: 'Aprobación de pintura para fachada principal',
      description: 'Se propone el tono gris perla para el mantenimiento trimestral de las torres. ¿Está de acuerdo?',
      endDate: '25 de Mayo, 2026',
      hasVoted: false,
    ),
    PollModel(
      id: 'poll_02',
      title: 'Horario de mantenimiento de la piscina',
      description: 'Cambiar el día de limpieza profunda de lunes a martes por solicitud general.',
      endDate: '30 de Mayo, 2026',
      hasVoted: true,
      selectedOption: 'Sí, de acuerdo',
    ),
  ];

  void _vote(PollModel poll, String option) {
    setState(() {
      poll.hasVoted = true;
      poll.selectedOption = option;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Su voto ha sido registrado con éxito!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Asambleas y Votaciones'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _polls.length,
        itemBuilder: (context, index) {
          final poll = _polls[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.how_to_vote, color: Colors.indigo),
                      Text('Cierra: ${poll.endDate}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    poll.title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    poll.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.3),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  poll.hasVoted
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                'Has votado: "${poll.selectedOption}"',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _vote(poll, 'En Contra'),
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                                child: const Text('En Contra', style: TextStyle(color: Colors.red)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomButton(
                                text: 'Aprobar',
                                backgroundColor: Colors.indigo.shade900,
                                onPressed: () => _vote(poll, 'Sí, de acuerdo'),
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