import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import '../models/audio_analysis.dart';

class ApiService {
  final Dio _dio = Dio();
  // Cambiar esta URL cuando se despliegue el backend
  final String baseUrl = 'http://localhost:8000';

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<AudioAnalysis> analyzeAudio(dynamic audioFile) async {
    try {
      FormData formData;

      if (kIsWeb && audioFile is String) {
        // Para Web: audioFile es un String (blob URL)
        // En Web, necesitamos usar file_picker o directamente subir desde el input
        throw Exception(
          'Para Web, por favor sube un archivo de audio usando el botón "Subir archivo de audio".',
        );
      } else if (!kIsWeb && audioFile is File) {
        // Para móvil: audioFile es un File
        final file = audioFile as File;
        final fileName = path.basename(file.path);
        formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        });
      } else {
        throw Exception('Formato de archivo no soportado');
      }

      final response = await _dio.post(
        '/analyze',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      if (response.statusCode == 200) {
        return AudioAnalysis.fromJson(response.data);
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Tiempo de espera agotado. Verifica tu conexión.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No se pudo conectar al servidor. Verifica que el backend esté corriendo.');
      } else if (e.response != null) {
        throw Exception(
            'Error del servidor: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Error de red: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error al analizar audio: $e');
    }
  }

  Future<AudioAnalysis> getAnalysis(String analysisId) async {
    try {
      final response = await _dio.get('/analysis/$analysisId');
      if (response.statusCode == 200) {
        return AudioAnalysis.fromJson(response.data);
      } else {
        throw Exception('Error al obtener análisis');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('No se pudo conectar al servidor.');
      }
      throw Exception('Error al obtener análisis: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<AudioAnalysis>> getAnalysisHistory() async {
    try {
      final response = await _dio.get('/history');
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((json) => AudioAnalysis.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener historial');
      }
    } catch (e) {
      throw Exception('Error al obtener historial: $e');
    }
  }

  Future<bool> deleteAnalysis(String analysisId) async {
    try {
      final response = await _dio.delete('/analysis/$analysisId');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkConnection() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

