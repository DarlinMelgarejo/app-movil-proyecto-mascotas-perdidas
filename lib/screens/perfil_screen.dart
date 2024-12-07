import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Asegúrate de usar la ruta correcta a `auth_service.dart`
import 'login_screen.dart'; // Asegúrate de tener esta pantalla para redirigir tras cerrar sesión

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final AuthService _authService = AuthService();
  String userName = "Cargando...";
  String userEmail = "Cargando...";
  String userPhone = "Cargando...";
  bool _isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Cargar el perfil del usuario desde la API
  Future<void> _loadUserProfile() async {
    final response = await _authService.obtenerPerfil();
    if (response['success']) {
      setState(() {
        userName = response['data']['nombres'] + " " + response['data']['apellidos'] ?? "Sin nombre";
        userEmail = response['data']['correo'] ?? "Sin correo";
        userPhone = response['data']['telefono'] ?? "Sin teléfono";
        _isLoading = false; // Desactiva el indicador de carga
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al cargar el perfil")),
      );
    }
  }


  // Cerrar sesión
  Future<void> _cerrarSesion() async {
    final response = await _authService.cerrarSesion();
    if (response['success']) {
      // Redirigir al inicio de sesión después de cerrar sesión
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al cerrar sesión")),
      );
    }
  }


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
        child: _isLoading
            ? CircularProgressIndicator() // Muestra un indicador de carga mientras se carga el perfil
            : Column(
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
                        SnackBar(content: Text('Función de edición en el sitio web.')),
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
                    onPressed: _cerrarSesion,
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
