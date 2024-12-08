import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart'; // Para manejar tipos MIME

class ReportService {
  final String _baseUrl = 'https://backend-proyecto-mascotas-perdidas.onrender.com/api/reportes-mascotas';

  // Obtener todos los reportes de mascotas
  Future<Map<String, dynamic>> obtenerTodosLosReportes() async {
    final url = Uri.parse('$_baseUrl/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'reportes': data['reportes'],
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['mensaje'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  // Registrar un nuevo reporte
  Future<Map<String, Object?>> registrarReporte({
    required String fechaReporte,
    required String nombreMascota,
    required String especieMascota,
    required String razaMascota,
    required String colorMascota,
    required String sexoMascota,
    required String edadMascota,
    required String descripcionMascota,
    File? fotoMascota,
    required String estadoMascota,
    required String procedenciaMascota,
    required String ubicacionMascota,
    required double latitudUbicacion,
    required double longitudUbicacion,
  }) async {
    final url = Uri.parse('$_baseUrl/registrar');

    try {
      final request = http.MultipartRequest('POST', url);

      // Obtener el token de manera segura
      String? token = await FlutterSecureStorage().read(key: 'token');

      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'No se encontró el token de autenticación.',
        };
      }

      // Agregar encabezados
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Agregar campos del formulario
      request.fields.addAll({
        'fecha_reporte': fechaReporte,
        'nombre_mascota': nombreMascota,
        'especie_mascota': especieMascota,
        'raza_mascota': razaMascota,
        'color_mascota': colorMascota,
        'sexo_mascota': sexoMascota,
        'edad_mascota': edadMascota,
        'descripcion_mascota': descripcionMascota,
        'estado_mascota': estadoMascota,
        'procedencia_mascota': procedenciaMascota,
        'ubicacion_mascota': ubicacionMascota,
        'latitud_ubicacion': latitudUbicacion.toString(),
        'longitud_ubicacion': longitudUbicacion.toString(),
      });

      // Verificar si hay una imagen adjunta
      if (fotoMascota != null && fotoMascota.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto_mascota',
          fotoMascota.path,
          contentType: MediaType('image', 'jpg'), // Asegura el formato correcto
        ));
      } else {
        print("Advertencia: No se proporcionó una imagen válida.");
      }

      // Enviar la solicitud
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['mensaje'],
          'reporte': data['reporte'],
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['mensaje'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
}
