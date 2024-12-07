import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'https://backend-proyecto-mascotas-perdidas.onrender.com/api/usuarios';
  final http.Client _client;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();  // Instancia de FlutterSecureStorage

  AuthService() : _client = http.Client();

  // Método para iniciar sesión
  Future<Map<String, dynamic>> logear(String dni, String password, bool rememberMe) async {
    final url = Uri.parse('$_baseUrl/logear');
    try {
      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'dni': dni,
          'contraseña': password,
          'recordarme': rememberMe,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verificamos si el token está presente en la respuesta
        if (data.containsKey('token')) {
          String token = data['token'];  // Asumiendo que el backend te devuelve el token en el JSON

          // Guardar el token de forma segura usando flutter_secure_storage
          await _secureStorage.write(key: 'token', value: token);

          return {'success': true};
        } else {
          return {'success': false, 'message': 'Token no encontrado en la respuesta'};
        }
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['mensaje'] ?? 'Error desconocido'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Método para obtener el perfil del usuario logueado
  Future<Map<String, dynamic>> obtenerPerfil() async {
    final url = Uri.parse('$_baseUrl/perfil');
    try {
      // Obtener el token de manera segura
      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {
        return {'success': false, 'message': 'No se encontró el token'};
      }

      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token como Bearer en el encabezado
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verificamos si el usuario está presente en la respuesta
        if (data.containsKey('usuario')) {
          return {'success': true, 'data': data['usuario']};
        } else {
          return {'success': false, 'message': 'No se encontró el usuario en la respuesta'};
        }
      } else {
        return {'success': false, 'message': 'Error al obtener perfil, código de estado: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // Método para cerrar sesión
  Future<Map<String, dynamic>> cerrarSesion() async {
    final url = Uri.parse('$_baseUrl/cerrar-sesion');
    try {
      // Obtener el token de manera segura
      String? token = await _secureStorage.read(key: 'token');

      if (token == null) {
        return {'success': false, 'message': 'No se encontró el token'};
      }

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token como Bearer en el encabezado
        },
      );

      if (response.statusCode == 200) {
        // Borrar el token después de cerrar sesión
        await _secureStorage.delete(key: 'token');
        return {'success': true, 'message': 'Sesión cerrada con éxito'};
      } else {
        return {'success': false, 'message': 'Error al cerrar sesión'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }
}
