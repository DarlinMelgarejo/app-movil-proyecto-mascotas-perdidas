import 'package:flutter/material.dart';

class InicioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Animales Encontrados',
          style: TextStyle(color: Colors.white), // Texto en blanco
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Icono en blanco
      ),
      body: SingleChildScrollView(
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
                        // Lógica para reportar un animal
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
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.pets, color: Colors.teal),
                    ),
                    title: Text(['Max', 'Luna', 'Rocky', 'Milo'][index]),
                    subtitle: Text([
                      'Perro - Parque Central',
                      'Gato - Avenida Principal',
                      'Perro - Plaza Mayor',
                      'Gato - Calle 5'
                    ][index]),
                    trailing: Chip(
                      label: Text(
                        index % 2 == 0 ? 'Perdido' : 'Encontrado',
                        style: TextStyle(
                          color: index % 2 == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                      backgroundColor: index % 2 == 0
                          ? Colors.red
                          : Colors.grey.shade300,
                    ),
                  );
                },
              ),

              // Sección de estadísticas
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  StatisticCard(
                    count: 152,
                    label: 'Animales Reportados',
                    color: Colors.teal,
                  ),
                  StatisticCard(
                    count: 89,
                    label: 'Animales Encontrados',
                    color: Colors.amber,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para las tarjetas de estadísticas
class StatisticCard extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const StatisticCard({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
