import 'package:app_movil/screens/reportar_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/services/report_service.dart';

class InicioScreen extends StatefulWidget {
  @override
  _InicioScreenState createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final ReportService _reportService = ReportService();
  List<dynamic> _reportes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReportes();
  }

  Future<void> _fetchReportes() async {
    final response = await _reportService.obtenerTodosLosReportes();
    if (response['success']) {
      setState(() {
        _reportes = response['reportes'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Error al cargar reportes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Huellas Perdidas',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Barra de búsqueda
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Buscar animales...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Botones de opciones
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ReportarScreen()),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Reportar Animal'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Lógica para ver el mapa
                            },
                            icon: const Icon(Icons.map),
                            label: const Text('Ver Mapa'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // Lista de animales recientes
                    const Text(
                      'Animales Recientes',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _reportes.length,
                      itemBuilder: (context, index) {
                        final reporte = _reportes[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: reporte['url_foto_mascota'] != null
                                ? NetworkImage(reporte['url_foto_mascota'])
                                : null,
                            child: reporte['url_foto_mascota'] == null
                                ? const Icon(Icons.pets, color: Colors.teal)
                                : null,
                          ),
                          title: Text(reporte['nombre_mascota'] ?? 'Sin nombre'),
                          subtitle: Text(
                              '${reporte['especie_mascota']} - ${reporte['ubicacion_mascota']}'),
                          trailing: Chip(
                            label: Text(
                              reporte['estado_mascota'] ?? 'Desconocido',
                              style: TextStyle(
                                color: reporte['estado_mascota'] == 'Perdido'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            backgroundColor: reporte['estado_mascota'] == 'Perdido'
                                ? Colors.red
                                : Colors.grey.shade300,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}