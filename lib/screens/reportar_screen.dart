import 'package:flutter/material.dart';

class ReportAnimalScreen extends StatefulWidget {
  @override
  _ReportAnimalScreenState createState() => _ReportAnimalScreenState();
}

class _ReportAnimalScreenState extends State<ReportAnimalScreen> {
  String reportType = 'Perdido'; // Por defecto: Perdido
  String? selectedSpecies;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Reporte Animal',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección: Información del Animal
            Text(
              'Información del Animal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Tipo de Reporte', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Perdido'),
                    value: 'Perdido',
                    groupValue: reportType,
                    onChanged: (value) {
                      setState(() {
                        reportType = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Encontrado'),
                    value: 'Encontrado',
                    groupValue: reportType,
                    onChanged: (value) {
                      setState(() {
                        reportType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Especie', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              isExpanded: true,
              hint: Text('Seleccionar'),
              value: selectedSpecies,
              items: ['Perro', 'Gato', 'Otro'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedSpecies = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Descripción', style: TextStyle(fontSize: 16)),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Describe el animal y cualquier característica distintiva',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 30),

            // Sección: Detalles del Incidente
            Text(
              'Detalles del Incidente',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Fecha', style: TextStyle(fontSize: 16)),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: selectedDate == null
                    ? 'dd/mm/aaaa'
                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            Text('Ubicación', style: TextStyle(fontSize: 16)),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'Dirección o punto de referencia',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 20),
            Text('Teléfono o Email', style: TextStyle(fontSize: 16)),
            TextField(
              controller: contactController,
              decoration: InputDecoration(
                hintText: 'Teléfono o Email de contacto',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),

            // Botón de envío
            ElevatedButton(
              onPressed: () {
                // Lógica de envío
                print('Tipo de Reporte: $reportType');
                print('Especie: $selectedSpecies');
                print('Descripción: ${descriptionController.text}');
                print('Fecha: ${selectedDate ?? "No seleccionada"}');
                print('Ubicación: ${locationController.text}');
                print('Contacto: ${contactController.text}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Enviar Reporte'),
            ),
          ],
        ),
      ),
    );
  }
}
