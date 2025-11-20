"""
Backend FastAPI para PitchMaster AI
Maneja transcripción de audio, análisis de comunicación y feedback usando Groq API
"""

from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import os
import tempfile
import whisper
from groq import Groq
from typing import List, Dict, Any
import json
import uuid
from datetime import datetime
import librosa
import numpy as np

# Intentar cargar variables de entorno desde .env
try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass  # python-dotenv no está instalado, usar solo variables de entorno del sistema

app = FastAPI(title="PitchMaster AI API")

# Configuración CORS para permitir conexiones desde Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, especificar dominios permitidos
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inicializar modelos
WHISPER_MODEL = None
GROQ_CLIENT = None

# API Key de Groq - Obtener de variable de entorno o archivo .env
# Para usar archivo .env, instala python-dotenv: pip install python-dotenv
GROQ_API_KEY = os.getenv("GROQ_API_KEY", "")

# Si no hay API key, mostrar advertencia
if not GROQ_API_KEY:
    print("⚠️  ADVERTENCIA: GROQ_API_KEY no está configurada. El análisis con LLM no funcionará.")
    print("   Configura la variable de entorno GROQ_API_KEY o crea un archivo .env")

@app.on_event("startup")
async def startup_event():
    """Inicializar modelos al arrancar el servidor"""
    global WHISPER_MODEL, GROQ_CLIENT
    try:
        print("Cargando modelo Whisper...")
        WHISPER_MODEL = whisper.load_model("base")
        print("Modelo Whisper cargado")
    except Exception as e:
        print(f"Error al cargar Whisper: {e}")
    
    try:
        GROQ_CLIENT = Groq(api_key=GROQ_API_KEY)
        print("Cliente Groq inicializado")
    except Exception as e:
        print(f"Error al inicializar Groq: {e}")

@app.get("/health")
async def health_check():
    """Endpoint de salud"""
    return {"status": "ok", "whisper_loaded": WHISPER_MODEL is not None, "groq_loaded": GROQ_CLIENT is not None}

@app.post("/analyze")
async def analyze_audio(file: UploadFile = File(...)):
    """
    Analiza un archivo de audio y devuelve transcripción y feedback
    """
    try:
        # Guardar archivo temporalmente
        with tempfile.NamedTemporaryFile(delete=False, suffix=".wav") as tmp_file:
            content = await file.read()
            tmp_file.write(content)
            tmp_path = tmp_file.name

        try:
            # 1. Transcripción con Whisper
            print(f"Transcribiendo audio: {tmp_path}")
            result = WHISPER_MODEL.transcribe(tmp_path, language="es")
            transcription = result["text"]
            segments_data = result["segments"]

            # 2. Analizar audio para extraer características
            y, sr = librosa.load(tmp_path)
            duration = len(y) / sr

            # Calcular características de audio
            audio_features = analyze_audio_features(y, sr, segments_data)

            # 3. Análisis con Groq LLM
            analysis_prompt = create_analysis_prompt(transcription, audio_features)
            feedback = await analyze_with_groq(analysis_prompt)

            # 4. Detectar emociones
            emotion_analysis = await detect_emotions_with_groq(transcription, audio_features)

            # 5. Generar feedback estructurado
            structured_feedback = generate_structured_feedback(feedback, segments_data)

            # Construir respuesta
            analysis_id = str(uuid.uuid4())
            response = {
                "id": analysis_id,
                "audio_url": "",  # En producción, subir a almacenamiento
                "transcription": transcription,
                "segments": create_segments(segments_data, audio_features),
                "predominant_emotion": emotion_analysis.get("predominant", "neutral"),
                "emotion_distribution": emotion_analysis.get("distribution", {}),
                "feedbacks": structured_feedback,
                "scores": calculate_scores(feedback, emotion_analysis, audio_features),
                "created_at": datetime.now().isoformat(),
            }

            return JSONResponse(content=response)

        finally:
            # Limpiar archivo temporal
            if os.path.exists(tmp_path):
                os.unlink(tmp_path)

    except Exception as e:
        print(f"Error al analizar audio: {e}")
        raise HTTPException(status_code=500, detail=f"Error al analizar audio: {str(e)}")

def analyze_audio_features(y, sr, segments):
    """Analiza características del audio"""
    features = {
        "duration": len(y) / sr,
        "average_volume": float(np.mean(np.abs(y))),
        "speech_rate": calculate_speech_rate(segments),
        "pauses": detect_pauses(segments),
        "pitch": calculate_pitch(y, sr),
    }
    return features

def calculate_speech_rate(segments):
    """Calcula palabras por minuto"""
    if not segments:
        return 150.0  # Default
    
    total_words = sum(len(seg.get("text", "").split()) for seg in segments)
    total_time = segments[-1].get("end", 0) - segments[0].get("start", 0)
    
    if total_time == 0:
        return 150.0
    
    wpm = (total_words / total_time) * 60
    return float(wpm)

def detect_pauses(segments):
    """Detecta pausas entre segmentos"""
    pauses = []
    for i in range(len(segments) - 1):
        gap = segments[i + 1]["start"] - segments[i]["end"]
        if gap > 0.5:  # Pausa mayor a 0.5 segundos
            pauses.append({
                "start": segments[i]["end"],
                "end": segments[i + 1]["start"],
                "duration": gap
            })
    return pauses

def calculate_pitch(y, sr):
    """Calcula frecuencia fundamental promedio"""
    try:
        pitches, magnitudes = librosa.piptrack(y=y, sr=sr)
        pitch_values = []
        for t in range(pitches.shape[1]):
            index = magnitudes[:, t].argmax()
            pitch = pitches[index, t]
            if pitch > 0:
                pitch_values.append(pitch)
        
        if pitch_values:
            return float(np.mean(pitch_values))
        return 150.0  # Default
    except:
        return 150.0

def create_analysis_prompt(transcription, audio_features):
    """Crea el prompt para análisis con Groq"""
    prompt = f"""
Analiza el siguiente pitch y proporciona feedback detallado sobre:

1. CLARIDAD: ¿El mensaje es claro y comprensible?
2. FLUJO: ¿La estructura y el flujo son lógicos?
3. CONTEXTO: ¿Hay suficiente contexto para entender el mensaje?
4. TECNICISMOS: ¿El uso de tecnicismos es apropiado?
5. LONGITUD DE FRASES: ¿Las frases son demasiado largas o cortas?
6. MULETILLAS: ¿Hay muletillas excesivas (eh, mm, bueno, etc.)?
7. TONO EMOCIONAL: ¿El tono es apropiado (pasivo, agresivo, inseguro, robótico)?
8. PAUSAS: ¿Hay pausas incómodas o falta de respiración?

Transcripción: "{transcription}"

Características del audio:
- Velocidad de habla: {audio_features.get('speech_rate', 0):.1f} palabras/minuto
- Duración: {audio_features.get('duration', 0):.2f} segundos
- Pausas detectadas: {len(audio_features.get('pauses', []))}

Proporciona feedback específico con:
- Puntuación de 0-100 para cada dimensión
- Comentarios específicos sobre áreas de mejora
- Sugerencias concretas y accionables
- Identificación de momentos específicos que necesitan atención

Responde en formato JSON con esta estructura:
{{
    "clarity": {{"score": 85, "comment": "...", "issues": [...]}},
    "flow": {{"score": 75, "comment": "...", "issues": [...]}},
    "context": {{"score": 80, "comment": "...", "issues": [...]}},
    "technicality": {{"score": 70, "comment": "...", "issues": [...]}},
    "sentence_length": {{"score": 65, "comment": "...", "issues": [...]}},
    "fillers": {{"score": 90, "comment": "...", "issues": [...]}},
    "emotional_tone": {{"score": 78, "comment": "...", "issues": [...]}},
    "pauses": {{"score": 82, "comment": "...", "issues": [...]}},
    "general_feedback": "..."
}}
"""
    return prompt

async def analyze_with_groq(prompt):
    """Analiza usando Groq LLM"""
    try:
        response = GROQ_CLIENT.chat.completions.create(
            model="llama-3.1-70b-versatile",
            messages=[
                {"role": "system", "content": "Eres un experto coach de comunicación y oratoria. Analiza pitches y proporciona feedback constructivo y accionable."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.7,
            max_tokens=2000,
        )
        
        content = response.choices[0].message.content
        
        # Intentar parsear JSON
        try:
            # Buscar JSON en la respuesta
            json_start = content.find('{')
            json_end = content.rfind('}') + 1
            if json_start != -1 and json_end > json_start:
                json_str = content[json_start:json_end]
                return json.loads(json_str)
        except:
            pass
        
        # Si no se puede parsear, devolver respuesta de texto
        return {"general_feedback": content}
    except Exception as e:
        print(f"Error en análisis Groq: {e}")
        # Devolver análisis por defecto
        return {
            "clarity": {"score": 75, "comment": "Análisis no disponible", "issues": []},
            "flow": {"score": 75, "comment": "Análisis no disponible", "issues": []},
            "context": {"score": 75, "comment": "Análisis no disponible", "issues": []},
            "technicality": {"score": 75, "comment": "Análisis no disponible", "issues": []},
            "sentence_length": {"score": 75, "comment": "Análisis no disponible", "issues": []},
            "fillers": {"score": 75, "comment": "Análisis no disponible", "issues": []},
            "emotional_tone": {"score": 75, "comment": "Análisis no disponible", "issues": []},
            "pauses": {"score": 75, "comment": "Análisis no disponible", "issues": []},
        }

async def detect_emotions_with_groq(transcription, audio_features):
    """Detecta emociones usando Groq"""
    try:
        prompt = f"""
Analiza la siguiente transcripción y detecta la emoción predominante:
"{transcription}"

Características del audio:
- Velocidad: {audio_features.get('speech_rate', 0):.1f} palabras/minuto
- Tono: {audio_features.get('pitch', 0):.1f} Hz

Emociones posibles: happy, calm, confident, anxious, neutral, energetic, insecure, robotic

Responde en formato JSON:
{{
    "predominant": "neutral",
    "distribution": {{
        "happy": 0.1,
        "calm": 0.2,
        "confident": 0.3,
        "anxious": 0.1,
        "neutral": 0.15,
        "energetic": 0.05,
        "insecure": 0.08,
        "robotic": 0.02
    }}
}}
"""
        response = GROQ_CLIENT.chat.completions.create(
            model="llama-3.1-70b-versatile",
            messages=[
                {"role": "system", "content": "Eres un experto en análisis de emociones en comunicación verbal."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.5,
            max_tokens=500,
        )
        
        content = response.choices[0].message.content
        json_start = content.find('{')
        json_end = content.rfind('}') + 1
        if json_start != -1 and json_end > json_start:
            json_str = content[json_start:json_end]
            return json.loads(json_str)
    except Exception as e:
        print(f"Error en detección de emociones: {e}")
    
    # Default
    return {
        "predominant": "neutral",
        "distribution": {
            "happy": 0.1,
            "calm": 0.1,
            "confident": 0.2,
            "anxious": 0.1,
            "neutral": 0.4,
            "energetic": 0.05,
            "insecure": 0.05,
            "robotic": 0.0
        }
    }

def generate_structured_feedback(analysis, segments):
    """Genera feedback estructurado con referencias temporales"""
    feedbacks = []
    
    # Extraer issues de cada dimensión
    dimensions = ["clarity", "flow", "context", "technicality", "sentence_length", 
                  "fillers", "emotional_tone", "pauses"]
    
    for dim in dimensions:
        if dim in analysis and isinstance(analysis[dim], dict):
            dim_data = analysis[dim]
            issues = dim_data.get("issues", [])
            
            for i, issue in enumerate(issues):
                # Estimar tiempo basado en posición en el texto
                segment_idx = min(i, len(segments) - 1) if segments else 0
                start_time = int(segments[segment_idx].get("start", 0) * 1000) if segments else 0
                end_time = int(segments[segment_idx].get("end", 0) * 1000) if segments else start_time + 5000
                
                feedbacks.append({
                    "id": str(uuid.uuid4()),
                    "message": issue if isinstance(issue, str) else dim_data.get("comment", ""),
                    "category": dim,
                    "start_time": start_time // 1000,
                    "end_time": end_time // 1000,
                    "severity": "medium",
                    "suggestion": dim_data.get("comment", ""),
                    "score": dim_data.get("score", 75)
                })
    
    return feedbacks

def create_segments(segments_data, audio_features):
    """Crea segmentos de transcripción con características"""
    segments = []
    speech_rate = audio_features.get("speech_rate", 150)
    
    for seg in segments_data:
        text = seg.get("text", "").strip()
        if not text:
            continue
        
        words_count = len(text.split())
        duration = seg.get("end", 0) - seg.get("start", 0)
        wpm = (words_count / duration * 60) if duration > 0 else speech_rate
        
        segments.append({
            "text": text,
            "start_time": int(seg.get("start", 0) * 1000),
            "end_time": int(seg.get("end", 0) * 1000),
            "speed": float(wpm),
            "volume": float(audio_features.get("average_volume", 0.5)),
            "pitch": float(audio_features.get("pitch", 150)),
            "has_pause": False,  # Se puede mejorar con análisis de pausas
            "emphasis": "normal"
        })
    
    return segments

def calculate_scores(analysis, emotion_analysis, audio_features):
    """Calcula scores numéricos de 0-100"""
    scores = {}
    
    dimensions = ["clarity", "flow", "context", "technicality", "sentence_length",
                  "fillers", "emotional_tone", "pauses"]
    
    for dim in dimensions:
        if dim in analysis and isinstance(analysis[dim], dict):
            scores[dim] = float(analysis[dim].get("score", 75))
        else:
            scores[dim] = 75.0
    
    # Normalizar nombres para el modelo
    return {
        "clarity": scores.get("clarity", 75),
        "flow": scores.get("flow", 75),
        "context": scores.get("context", 75),
        "technicality": scores.get("technicality", 75),
        "sentence_length": scores.get("sentence_length", 75),
        "fillers": scores.get("fillers", 75),
        "emotional_tone": scores.get("emotional_tone", 75),
        "pauses": scores.get("pauses", 75),
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

