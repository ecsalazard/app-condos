import 'package:flutter/material.dart';
import 'views/auth/login_view.dart'; // Importamos la pantalla de login que creamos

void main() {
  // 1. Aquí arranca todo
  runApp(const MiCondominioApp());
}

class MiCondominioApp extends StatelessWidget {
  const MiCondominioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Condominios',
      debugShowCheckedModeBanner: false, // Oculta la etiqueta roja de "DEBUG"
      
      // 2. Definimos el tema visual general de la app (colores, diseño Material 3)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      
      // 3. Indicamos cuál es la primera pantalla que verá el usuario al abrir la app
      home: const LoginView(),
    );
  }
}