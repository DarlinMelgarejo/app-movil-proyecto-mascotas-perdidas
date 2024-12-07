import 'package:flutter/material.dart';
import 'package:app_movil/screens/reportar_screen.dart';
import 'package:app_movil/screens/inicio_screen.dart';
import 'package:app_movil/screens/perfil_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  // Lista de páginas que se mostrarán al presionar los botones
  final List<Widget> _pages = [
    InicioScreen(),
    ReportAnimalScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Página actual basada en el índice
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Índice del botón seleccionado
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Cambiar la página según el botón seleccionado
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Reporte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        selectedItemColor: Colors.teal, // Color del botón seleccionado
        unselectedItemColor: Colors.grey, // Color de los botones no seleccionados
        backgroundColor: Colors.white, // Fondo de la barra
      ),
    );
  }
}
