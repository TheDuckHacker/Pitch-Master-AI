# Backend PitchMaster AI

Backend FastAPI para PitchMaster AI que maneja transcripción de audio y análisis de comunicación.

## Instalación

```bash
pip install -r requirements.txt
```

## Configuración

La API key de Groq se puede configurar mediante variable de entorno:
```bash
export GROQ_API_KEY="tu_api_key_aqui"
```

O se usa la API key por defecto en el código.

## Ejecutar

```bash
python main.py
```

El servidor se ejecutará en http://localhost:8000

## Endpoints

- `GET /health` - Verificar estado del servidor
- `POST /analyze` - Analizar archivo de audio (multipart/form-data con campo "file")

## Notas

- El modelo Whisper se carga al iniciar el servidor (puede tardar unos segundos)
- Para producción, considerar usar un servicio de transcripción en la nube
- Los archivos de audio se procesan temporalmente y se eliminan después del análisis

