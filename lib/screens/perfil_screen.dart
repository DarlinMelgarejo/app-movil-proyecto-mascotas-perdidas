import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  final String userName = "Ana García";
  final String userEmail = "ana.garcia@example.com";
  final String userPhone = "+34 123 456 789";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen del perfil
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 16),
            // Información del usuario
            Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              userPhone,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            // Botones de acciones
            ElevatedButton.icon(
              onPressed: () {
                // Acción para editar perfil
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Función de edición no implementada.')),
                );
              },
              icon: Icon(Icons.edit),
              label: Text('Editar Perfil'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Acción para cerrar sesión
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Función de cerrar sesión no implementada.')),
                );
              },
              icon: Icon(Icons.logout),
              label: Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
