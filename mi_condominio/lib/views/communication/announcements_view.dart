import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

// Modelo local para representar un comunicado
class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String date;
  final String authorRole; // Ej: "Junta de Condominio" o "Administración"
  final bool isUrgent;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.authorRole,
    required this.isUrgent,
  });
}

class AnnouncementsView extends StatefulWidget {
  final bool isAdmin; // Define si puede publicar nuevos comunicados

  const AnnouncementsView({super.key, this.isAdmin = false});

  @override
  State<AnnouncementsView> createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> {
  // Lista simulada de comunicados
  final List<AnnouncementModel> _announcements = [
    AnnouncementModel(
      id: 'ann_01',
      title: 'Corte programado de suministro de agua',
      content: 'Informamos a todos los copropietarios que el próximo jueves se realizará un mantenimiento en la bomba principal. El servicio será interrumpido de 8:00 AM a 2:00 PM.',
      date: '18 de Mayo, 2026',
      authorRole: 'Administración',
      isUrgent: true,
    ),
    AnnouncementModel(
      id: 'ann_02',
      title: 'Convocatoria a Asamblea General Ordinaria',
      content: 'Se convoca a los propietarios a la asamblea anual que se llevará a cabo en el Salón de Fiestas el próximo sábado a las 10:00 AM. Su asistencia es de suma importancia.',
      date: '15 de Mayo, 2026',
      authorRole: 'Junta de Condominio',
      isUrgent: false,
    ),
    AnnouncementModel(
      id: 'ann_03',
      title: 'Normas para el uso de la piscina y áreas recreativas',
      content: 'Recordamos a los residentes el horario de uso de la piscina (de 7:00 AM a 9:00 PM) y la prohibición de envases de vidrio en el área perimetral.',
      date: '10 de Mayo, 2026',
      authorRole: 'Administración',
      isUrgent: false,
    ),
  ];

  void _showNewAnnouncementModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _NewAnnouncementForm(
        onAnnouncementCreated: (newAnnouncement) {
          setState(() {
            _announcements.insert(0, newAnnouncement); // Lo pone de primero
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Comunicado publicado exitosamente!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Avisos y Comunicados'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
      ),
      body: _announcements.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.campaign_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay comunicados publicados',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _announcements.length,
              itemBuilder: (context, index) {
                final item = _announcements[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: item.isUrgent
                                      ? Colors.red.shade50
                                      : Colors.indigo.shade50,
                                  child: Icon(
                                    item.isUrgent
                                        .toString()
                                        .contains('true')
                                        ? Icons.priority_high
                                        : Icons.announcement,
                                    size: 16,
                                    color: item.isUrgent
                                        ? Colors.red
                                        : Colors.indigo,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.authorRole,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              item.date,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: item.isUrgent ? Colors.red.shade900 : Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.content,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      // Si es administrador, mostramos el botón para redactar un nuevo aviso
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton.extended(
              onPressed: _showNewAnnouncementModal,
              backgroundColor: Colors.indigo.shade900,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_comment),
              label: const Text('Nuevo Comunicado'),
            )
          : null,
    );
  }
}

// Formulario flotante para redactar avisos (Solo Administradores)
class _NewAnnouncementForm extends StatefulWidget {
  final Function(AnnouncementModel) onAnnouncementCreated;

  const _NewAnnouncementForm({required this.onAnnouncementCreated});

  @override
  State<_NewAnnouncementForm> createState() => _NewAnnouncementFormState();
}

class _NewAnnouncementFormState extends State<_NewAnnouncementForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isUrgent = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Publicar Nuevo Comunicado',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título del Comunicado',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Ingresa un título' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Contenido del mensaje',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Ingresa el contenido' : null,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Marcar como aviso urgente'),
                subtitle: const Text('Resaltará en color rojo para los residentes'),
                value: _isUrgent,
                activeColor: Colors.red,
                onChanged: (val) => setState(() => _isUrgent = val),
              ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Publicar Comunicado',
                  backgroundColor: Colors.indigo.shade900,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newAnnouncement = AnnouncementModel(
                        id: 'ann_${DateTime.now().millisecondsSinceEpoch}',
                        title: _titleController.text,
                        content: _contentController.text,
                        date: 'Hoy',
                        authorRole: 'Administración',
                        isUrgent: _isUrgent,
                      );
                      widget.onAnnouncementCreated(newAnnouncement);
                      Navigator.pop(context);
                    }
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}