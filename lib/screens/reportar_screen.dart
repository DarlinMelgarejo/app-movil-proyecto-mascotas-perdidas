import 'dart:io';
import 'package:app_movil/screens/inicio_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:app_movil/services/report_service.dart'; // Asegúrate de importar tu servicio

class ReportarScreen extends StatefulWidget {
  @override
  _ReportarScreenState createState() => _ReportarScreenState();
}

class _ReportarScreenState extends State<ReportarScreen> {
  final _formKey = GlobalKey<FormState>();
  late String nombreMascota,
      especieMascota,
      razaMascota,
      colorMascota,
      sexoMascota,
      edadMascota,
      descripcionMascota,
      estadoMascota,
      procedenciaMascota,
      ubicacionMascota;
  late DateTime fechaReporte;
  late LatLng posicionMapa;
  File? fotoMascota; // Cambiado a nullable (File?)

  final _imagePicker = ImagePicker();
  final TextEditingController _ubicacionController = TextEditingController();

  // Coordenadas para Pacasmayo y San Pedro de Lloc
  final Map<String, LatLng> coordenadasProcedencia = {
    'Pacasmayo': LatLng(-7.40111, -79.5722),
    'San Pedro de Lloc': LatLng(-7.43194, -79.5042)
  };

  @override
  void initState() {
    super.initState();
    fechaReporte = DateTime.now();
    estadoMascota = 'Perdido'; // Valor por defecto
    especieMascota = 'Perro';
    razaMascota = 'Desconocido';
    sexoMascota = 'Desconocido';
    colorMascota = '';
    edadMascota = '';
    procedenciaMascota = 'Pacasmayo'; // Valor por defecto
    posicionMapa = coordenadasProcedencia[procedenciaMascota]!; // Inicializamos con Pacasmayo
    ubicacionMascota = '';
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) { // 5 MB límite
        Fluttertoast.showToast(msg: 'La imagen es demasiado grande (máx. 5MB)');
        return;
      }
      setState(() {
        fotoMascota = file;
      });
    }
  }


    Future<void> _getAddressFromCoordinates(LatLng latlng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latlng.latitude, latlng.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          ubicacionMascota =
              '${place.name}, ${place.locality}, ${place.country}';
          _ubicacionController.text = ubicacionMascota;
        });
      } else {
        Fluttertoast.showToast(msg: 'No se encontró dirección');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al obtener la dirección');
    }
  }

  void _onMapTapped(LatLng latlng) {
    setState(() {
      posicionMapa = latlng;
    });
    _getAddressFromCoordinates(latlng);
  }

  void _onProcedenciaChanged(String? value) {
    if (value != null) {
      setState(() {
        procedenciaMascota = value;
        posicionMapa = coordenadasProcedencia[procedenciaMascota]!;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (fotoMascota == null) {
        Fluttertoast.showToast(msg: 'Por favor selecciona una foto de la mascota');
        return;
      }

      try {
        // Llamada al servicio para registrar el reporte
        final response = await ReportService().registrarReporte(
          fechaReporte: fechaReporte.toIso8601String(),
          nombreMascota: nombreMascota,
          especieMascota: especieMascota,
          razaMascota: razaMascota,
          colorMascota: colorMascota,
          sexoMascota: sexoMascota,
          edadMascota: edadMascota, // Convertir edad a entero
          descripcionMascota: descripcionMascota,
          fotoMascota: fotoMascota!, // Pasar el archivo como `File`
          estadoMascota: estadoMascota,
          procedenciaMascota: procedenciaMascota,
          ubicacionMascota: ubicacionMascota,
          latitudUbicacion: posicionMapa.latitude,
          longitudUbicacion: posicionMapa.longitude,
        );

        if (response['success'] == true) {
          Fluttertoast.showToast(msg: 'Reporte enviado con éxito');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InicioScreen()),
          );
        } else {
          Fluttertoast.showToast(msg: 'Error: ${response['message']}');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error al enviar el reporte: $e');
      }
    } else {
      Fluttertoast.showToast(msg: 'Por favor completa todos los campos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Reportar un Animal',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo de fecha
              TextFormField(
                decoration: InputDecoration(labelText: 'Fecha de Pérdida/Encuentro'),
                controller: TextEditingController(
                    text: fechaReporte.toLocal().toString().split(' ')[0]),
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: fechaReporte,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != fechaReporte) {
                    setState(() {
                      fechaReporte = pickedDate;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La fecha es obligatoria';
                  }
                  return null;
                },
              ),
              
              // Tipo de reporte: Perdido/Encontrado
              Column(
                children: [
                  Text("Tipo de reporte"),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text('Perdido'),
                          leading: Radio<String>(
                            value: 'Perdido',
                            groupValue: estadoMascota,
                            onChanged: (value) {
                              setState(() {
                                estadoMascota = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text('Encontrado'),
                          leading: Radio<String>(
                            value: 'Encontrado',
                            groupValue: estadoMascota,
                            onChanged: (value) {
                              setState(() {
                                estadoMascota = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),  
                ],
              ),

              // Especie
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Especie'),
                value: especieMascota,
                items: ['Perro', 'Gato', 'Otro']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    especieMascota = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona la especie';
                  }
                  return null;
                },
              ),

              // Nombre de la mascota
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre de la mascota (si se conoce)'),
                onChanged: (value) {
                  nombreMascota = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre de la mascota';
                  }
                  return null;
                },
              ),

              // Raza
              TextFormField(
                decoration: InputDecoration(labelText: 'Raza'),
                onChanged: (value) {
                  razaMascota = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la raza';
                  }
                  return null;
                },
              ),
              
              // Color
              TextFormField(
                decoration: InputDecoration(labelText: 'Color'),
                onChanged: (value) {
                  colorMascota = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el color';
                  }
                  return null;
                },
              ),
              
              // Sexo
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sexo'),
                value: sexoMascota,
                items: ['Desconocido', 'Macho', 'Hembra']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    sexoMascota = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona el sexo';
                  }
                  return null;
                },
              ),
              
              // Edad
              TextFormField(
                decoration: InputDecoration(labelText: 'Edad Aproximada'),
                onChanged: (value) {
                  edadMascota = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la edad';
                  }
                  return null;
                },
              ),
              
              // Procedencia
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Procedencia'),
                value: procedenciaMascota,
                items: ['Pacasmayo', 'San Pedro de Lloc']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: _onProcedenciaChanged,
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona la procedencia';
                  }
                  return null;
                },
              ),
              
              // Mapa interactivo
              Container(
                height: 300,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: posicionMapa,
                    initialZoom: 10,
                    onTap: (tapPosition, point) {
                      _onMapTapped(point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: posicionMapa,
                          child: Builder(
                            builder: (ctx) => Icon(Icons.pin_drop, color: Colors.red))
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Ubicación (muestra la ubicación en el mapa)
              TextFormField(
                controller: _ubicacionController,
                decoration: InputDecoration(labelText: 'Ubicación (en el mapa)'),
                readOnly: true,
              ),
              
              // Descripción
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                onChanged: (value) {
                  descripcionMascota = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              
              // Selección de foto
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Seleccionar Foto de Mascota'),
              ),
              fotoMascota != null
                  ? Image.file(fotoMascota!) // Mostrar la imagen seleccionada
                  : Container(),

              // Botón de envío
              ElevatedButton(
                onPressed: fotoMascota != null ? _submitForm : null,
                child: Text('Enviar Reporte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
