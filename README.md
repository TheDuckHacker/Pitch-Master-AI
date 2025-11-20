# PitchMaster AI

Aplicación Flutter completa para mejorar pitches mediante análisis de audio y feedback personalizado.

## Características

- ✅ Grabación de audio (Web y móvil)
- ✅ Subida de archivos de audio
- ✅ Transcripción automática con Whisper
- ✅ Análisis de comunicación con Groq LLM
- ✅ Chat con asistente AI
- ✅ Feedback puntual y accionable
- ✅ Detección de emociones
- ✅ Gamificación con niveles y logros
- ✅ Pantalla educativa con tips y ejercicios
- ✅ Adaptación emocional de UI con colores pasteles
- ✅ Tema claro/oscuro
- ✅ Historial de análisis

## Requisitos

- Flutter SDK 3.9.2 o superior
- Python 3.8+ (para el backend)
- API Key de Groq (obtener en [Groq Console](https://console.groq.com/))

## Instalación

### Flutter App

1. Instalar dependencias:
```bash
flutter pub get
```

2. Ejecutar la aplicación:
```bash
# Para Web
flutter run -d chrome

# Para Android
flutter run

# Para iOS
flutter run
```

### Backend Python

1. Instalar dependencias:
```bash
cd backend
pip install -r requirements.txt
```

2. Configurar API Key de Groq:

Crea un archivo `.env` en la carpeta `backend/` (puedes copiar `.env.example`):
```bash
cp backend/.env.example backend/.env
```

Edita `backend/.env` y agrega tu API key:
```
GROQ_API_KEY=tu_api_key_aqui
```

O configura la variable de entorno:
```bash
export GROQ_API_KEY="tu_api_key_aqui"
```

3. Ejecutar el servidor:
```bash
python main.py
```

El servidor se ejecutará en `http://localhost:8000`

## Configuración

### API Keys

**IMPORTANTE**: No subas tus API keys a GitHub. Usa variables de entorno o archivos `.env` que estén en `.gitignore`.

#### Para Flutter (Chat):
Configura la variable de entorno antes de ejecutar:
```bash
# En Windows (PowerShell)
$env:GROQ_API_KEY="tu_api_key"

# En Linux/Mac
export GROQ_API_KEY="tu_api_key"
```

O edita `lib/services/chat_service.dart` temporalmente para desarrollo local (pero no lo subas a Git).

#### Para Backend:
Usa el archivo `.env` como se explica arriba.

### Cambiar URL del Backend

Por defecto, la app Flutter busca el backend en `http://localhost:8000`. Para cambiarlo, edita `lib/services/api_service.dart`:

```dart
final String baseUrl = 'http://tu-servidor:8000';
```

Para Web, asegúrate de que el backend permita CORS desde el origen de tu app.

## Uso

1. **Grabar o subir audio**: Usa la pantalla principal para grabar un nuevo pitch o subir un archivo de audio.

2. **Analizar**: Después de grabar/subir, presiona "Enviar para análisis" para obtener feedback.

3. **Ver resultados**: Revisa tu transcripción, scores, feedback y sugerencias en la pantalla de análisis.

4. **Chat con asistente**: Usa la pestaña "Chat" para hacer preguntas sobre comunicación efectiva.

5. **Mejorar**: Sigue las sugerencias y graba nuevamente para comparar tu progreso.

6. **Aprender**: Visita la pantalla educativa para tips y ejercicios prácticos.

7. **Progresar**: Ve tu evolución en la pantalla de progreso con niveles y logros.

## Estructura del Proyecto

```
lib/
├── models/          # Modelos de datos
├── services/        # Servicios (audio, API, storage, theme, chat)
├── screens/         # Pantallas de la app
├── widgets/         # Widgets reutilizables
└── main.dart        # Punto de entrada

backend/
├── main.py          # Servidor FastAPI
├── requirements.txt # Dependencias Python
└── .env.example     # Ejemplo de configuración
```

## Tecnologías

- **Frontend**: Flutter (Dart)
- **Backend**: Python (FastAPI)
- **Transcripción**: OpenAI Whisper
- **Análisis LLM**: Groq API (Llama 3.1)
- **Audio Analysis**: Librosa
- **Grabación Web**: MediaRecorder API

## Notas

- El modelo Whisper se descarga automáticamente la primera vez (puede tardar)
- Para producción, considera usar servicios de transcripción en la nube
- Los archivos de audio se procesan temporalmente y se eliminan después
- La grabación en Web funciona en navegadores modernos (Chrome, Firefox, Edge)

## Licencia

Este proyecto es para fines educativos y demostrativos.

## Contribuir

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request
