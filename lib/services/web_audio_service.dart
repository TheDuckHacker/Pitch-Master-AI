import 'dart:async';
import 'dart:html' as html;
import 'package:uuid/uuid.dart';

class WebAudioService {
  html.MediaRecorder? _mediaRecorder;
  html.MediaStream? _stream;
  bool _isRecording = false;
  String? _currentRecordingBlobUrl;
  final List<html.Blob> _chunks = [];
  final _uuid = const Uuid();

  bool get isRecording => _isRecording;

  String? get currentRecordingBlobUrl => _currentRecordingBlobUrl;

  Future<bool> hasPermission() async {
    try {
      final stream = await html.window.navigator.mediaDevices?.getUserMedia({
        'audio': true,
      });
      if (stream != null) {
        // Detener el stream de prueba
        stream.getTracks().forEach((track) => track.stop());
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String> startRecording() async {
    if (_isRecording) {
      throw Exception('Ya se está grabando');
    }

    try {
      // Obtener acceso al micrófono
      final stream = await html.window.navigator.mediaDevices?.getUserMedia({
        'audio': {
          'echoCancellation': true,
          'noiseSuppression': true,
          'autoGainControl': true,
        },
      });

      if (stream == null) {
        throw Exception('No se pudo acceder al micrófono');
      }

      _stream = stream;

      // Crear MediaRecorder - usar constructor directo
      try {
        _mediaRecorder = html.MediaRecorder(_stream!, {
          'mimeType': 'audio/webm;codecs=opus',
          'audioBitsPerSecond': 128000,
        });
      } catch (e) {
        // Si el codec opus no está disponible, intentar sin codec específico
        _mediaRecorder = html.MediaRecorder(_stream!);
      }

      _chunks.clear();

      // Escuchar eventos de datos usando addEventListener
      _mediaRecorder!.addEventListener('dataavailable', (event) {
        final blobEvent = event as html.BlobEvent;
        if (blobEvent.data != null) {
          _chunks.add(blobEvent.data!);
        }
      }, false);

      // Iniciar grabación con timeslice de 100ms
      _mediaRecorder!.start(100);

      _isRecording = true;
      return 'web_recording_${_uuid.v4()}';
    } catch (e) {
      throw Exception('Error al iniciar la grabación: $e');
    }
  }

  Future<String> stopRecording() async {
    if (!_isRecording || _mediaRecorder == null) {
      throw Exception('No hay ninguna grabación en curso');
    }

    try {
      final completer = Completer<void>();

      // Escuchar evento onstop usando addEventListener
      _mediaRecorder!.addEventListener('stop', (event) {
        completer.complete();
      }, false);

      _mediaRecorder!.stop();
      await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Si no se dispara el evento en 5 segundos, continuar de todas formas
        },
      );

      // Detener todos los tracks del stream
      _stream?.getTracks().forEach((track) => track.stop());
      _stream = null;

      // Crear blob con los datos grabados
      if (_chunks.isEmpty) {
        throw Exception('No se capturó ningún audio');
      }

      final blob = html.Blob(_chunks, 'audio/webm');
      _currentRecordingBlobUrl = html.Url.createObjectUrlFromBlob(blob);

      _isRecording = false;
      _mediaRecorder = null;

      return _currentRecordingBlobUrl!;
    } catch (e) {
      _isRecording = false;
      _mediaRecorder = null;
      throw Exception('Error al detener la grabación: $e');
    }
  }

  Future<html.Blob> getRecordingBlob() async {
    if (_currentRecordingBlobUrl == null || _chunks.isEmpty) {
      throw Exception('No hay grabación disponible');
    }
    return html.Blob(_chunks, 'audio/webm');
  }

  Future<void> cancelRecording() async {
    if (_isRecording) {
      _mediaRecorder?.stop();
      _stream?.getTracks().forEach((track) => track.stop());
    }
    _chunks.clear();
    if (_currentRecordingBlobUrl != null) {
      html.Url.revokeObjectUrl(_currentRecordingBlobUrl!);
      _currentRecordingBlobUrl = null;
    }
    _isRecording = false;
    _mediaRecorder = null;
    _stream = null;
  }

  void dispose() {
    cancelRecording();
  }
}
