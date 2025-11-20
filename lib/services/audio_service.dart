import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'web_audio_service.dart' if (dart.library.html) 'web_audio_service.dart';

class AudioService {
  AudioRecorder? _recorder;
  WebAudioService? _webRecorder;
  bool _isRecording = false;
  String? _currentRecordingPath;
  final _uuid = const Uuid();

  AudioService() {
    if (kIsWeb) {
      _webRecorder = WebAudioService();
    } else {
      _recorder = AudioRecorder();
    }
  }

  bool get isRecording => _isRecording;

  String? get currentRecordingPath => _currentRecordingPath;

  Future<bool> hasPermission() async {
    if (kIsWeb) {
      // En Web, los permisos se manejan automáticamente
      return true;
    }
    if (_recorder == null) {
      return false;
    }
    try {
      return await _recorder!.hasPermission();
    } catch (e) {
      return false;
    }
  }

  Future<String> startRecording() async {
    if (_isRecording) {
      throw Exception('Ya se está grabando');
    }

    if (kIsWeb) {
      if (_webRecorder == null) {
        throw Exception('El grabador de audio web no está disponible');
      }

      final hasPerm = await _webRecorder!.hasPermission();
      if (!hasPerm) {
        throw Exception(
          'No se tienen permisos para grabar. Por favor, otorga permisos de micrófono en tu navegador.',
        );
      }

      try {
        final recordingId = await _webRecorder!.startRecording();
        _isRecording = true;
        _currentRecordingPath = recordingId;
        return recordingId;
      } catch (e) {
        throw Exception(
          'Error al iniciar la grabación: $e. Asegúrate de que el navegador tenga permisos de micrófono.',
        );
      }
    }

    if (_recorder == null) {
      throw Exception('El grabador de audio no está disponible');
    }

    final hasPerm = await hasPermission();
    if (!hasPerm) {
      throw Exception(
        'No se tienen permisos para grabar. Por favor, otorga permisos de micrófono en la configuración de la app.',
      );
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'recording_${_uuid.v4()}.m4a';
      final filePath = path.join(directory.path, fileName);

      await _recorder!.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      _isRecording = true;
      _currentRecordingPath = filePath;
      return filePath;
    } catch (e) {
      throw Exception(
        'Error al iniciar la grabación: $e. Asegúrate de que la app tenga permisos de micrófono.',
      );
    }
  }

  Future<String> stopRecording() async {
    if (!_isRecording) {
      throw Exception('No hay ninguna grabación en curso');
    }

    if (kIsWeb) {
      if (_webRecorder == null) {
        _isRecording = false;
        return _currentRecordingPath ?? '';
      }

      try {
        final blobUrl = await _webRecorder!.stopRecording();
        _isRecording = false;
        _currentRecordingPath = blobUrl;
        return blobUrl;
      } catch (e) {
        _isRecording = false;
        throw Exception('Error al detener la grabación: $e');
      }
    }

    if (_recorder == null) {
      _isRecording = false;
      return _currentRecordingPath ?? '';
    }

    try {
      final path = await _recorder!.stop();
      _isRecording = false;
      _currentRecordingPath = path;
      return path ?? '';
    } catch (e) {
      _isRecording = false;
      throw Exception('Error al detener la grabación: $e');
    }
  }

  Future<void> pauseRecording() async {
    if (!_isRecording) {
      throw Exception('No hay ninguna grabación en curso');
    }
    if (kIsWeb || _recorder == null) {
      return;
    }
    await _recorder!.pause();
  }

  Future<void> resumeRecording() async {
    if (!_isRecording) {
      throw Exception('No hay ninguna grabación en curso');
    }
    if (kIsWeb || _recorder == null) {
      return;
    }
    await _recorder!.resume();
  }

  Future<void> cancelRecording() async {
    if (_isRecording) {
      if (kIsWeb) {
        await _webRecorder?.cancelRecording();
      } else if (_recorder != null) {
        await _recorder!.stop();
        if (_currentRecordingPath != null) {
          try {
            final file = File(_currentRecordingPath!);
            if (await file.exists()) {
              await file.delete();
            }
          } catch (e) {
            // Ignorar errores al eliminar
          }
        }
      }
      _isRecording = false;
      _currentRecordingPath = null;
    }
  }

  Future<Duration?> getRecordingDuration() async {
    if (!_isRecording || _currentRecordingPath == null) {
      return null;
    }
    if (kIsWeb || _recorder == null) {
      return null;
    }
    try {
      await _recorder!.getAmplitude();
      // El recorder no tiene método directo para obtener duración
      // Necesitaríamos usar otro paquete o calcularlo de otra forma
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteRecording(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<File>> getRecordedFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.m4a') || f.path.endsWith('.wav'))
          .toList();
      return files;
    } catch (e) {
      return [];
    }
  }

  void dispose() {
    if (_isRecording) {
      if (kIsWeb) {
        _webRecorder?.cancelRecording();
      } else if (_recorder != null) {
        _recorder!.stop();
      }
    }
    _recorder?.dispose();
    _webRecorder?.dispose();
  }
}
