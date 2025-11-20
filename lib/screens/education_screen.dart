import 'package:flutter/material.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aprende')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tips de comunicación
            _SectionCard(
              title: 'Comunicación efectiva',
              tips: [
                _TipItem(
                  icon: Icons.schedule,
                  title: 'Máximo 12 segundos por idea',
                  description:
                      'Mantén tus ideas concisas. Cada concepto debe poder explicarse en menos de 12 segundos para mantener la atención.',
                ),
                _TipItem(
                  icon: Icons.language,
                  title: 'Evita tecnicismos innecesarios',
                  description:
                      'Usa un lenguaje claro y accesible. Si debes usar términos técnicos, explícalos brevemente.',
                ),
                _TipItem(
                  icon: Icons.help_outline,
                  title: 'Comienza con el problema',
                  description:
                      'No empieces por la solución. Primero establece el problema o necesidad que estás resolviendo.',
                ),
                _TipItem(
                  icon: Icons.lightbulb_outline,
                  title: 'Usa ejemplos concretos',
                  description:
                      'Los ejemplos reales ayudan a que tu audiencia comprenda y recuerde tu mensaje.',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Storytelling
            _SectionCard(
              title: 'Storytelling',
              tips: [
                _TipItem(
                  icon: Icons.book,
                  title: 'Estructura narrativa',
                  description:
                      'Usa la estructura clásica: contexto, conflicto, resolución. Esto mantiene a tu audiencia comprometida.',
                ),
                _TipItem(
                  icon: Icons.people,
                  title: 'Conecta emocionalmente',
                  description:
                      'Las historias conectan a nivel emocional. Incluye experiencias personales o casos reales.',
                ),
                _TipItem(
                  icon: Icons.auto_stories,
                  title: 'Sé auténtico',
                  description:
                      'Las historias más convincentes son las que son verdaderas y reflejan tu experiencia real.',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Manejo de muletillas
            _SectionCard(
              title: 'Manejo de muletillas',
              tips: [
                _TipItem(
                  icon: Icons.pause_circle,
                  title: 'Pausa en lugar de muletillas',
                  description:
                      'Si necesitas pensar, haz una pausa breve. Es mejor que llenar el silencio con "eh", "mm" o "bueno".',
                ),
                _TipItem(
                  icon: Icons.edit,
                  title: 'Prepárate previamente',
                  description:
                      'Practica tu pitch varias veces. Conocer tu contenido reduce la necesidad de muletillas.',
                ),
                _TipItem(
                  icon: Icons.record_voice_over,
                  title: 'Graba y escucha',
                  description:
                      'Graba tus presentaciones y escúchalas. Te ayudará a identificar y eliminar muletillas.',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Técnicas de respiración
            _SectionCard(
              title: 'Técnicas de respiración',
              tips: [
                _TipItem(
                  icon: Icons.air,
                  title: 'Respiración profunda',
                  description:
                      'Antes de hablar, toma 3 respiraciones profundas. Esto te ayuda a calmar los nervios.',
                ),
                _TipItem(
                  icon: Icons.timer,
                  title: 'Pausa para respirar',
                  description:
                      'Incorpora pausas naturales en tu discurso para respirar. Esto mejora tu ritmo y claridad.',
                ),
                _TipItem(
                  icon: Icons.sentiment_satisfied,
                  title: 'Control del ritmo',
                  description:
                      'Respirar adecuadamente te ayuda a controlar el ritmo de tu discurso y evitar hablar demasiado rápido.',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Control emocional
            _SectionCard(
              title: 'Control emocional',
              tips: [
                _TipItem(
                  icon: Icons.self_improvement,
                  title: 'Preparación mental',
                  description:
                      'Visualiza tu presentación exitosa antes de comenzar. Esto te ayuda a proyectar confianza.',
                ),
                _TipItem(
                  icon: Icons.emoji_emotions,
                  title: 'Encuentra tu tono',
                  description:
                      'Experimenta con diferentes tonos emocionales. Encuentra el que mejor se adapte a tu mensaje.',
                ),
                _TipItem(
                  icon: Icons.psychology,
                  title: 'Gestiona la ansiedad',
                  description:
                      'Si sientes ansiedad, reconócela. Respira profundamente y recuerda que el conocimiento está de tu lado.',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Ejercicios prácticos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ejercicios prácticos',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _PracticeExercise(
                      title: 'Ejercicio de velocidad',
                      description:
                          'Practica explicar tu idea principal en exactamente 12 segundos. Usa un cronómetro.',
                    ),
                    const Divider(),
                    _PracticeExercise(
                      title: 'Ejercicio de claridad',
                      description:
                          'Graba un pitch y después transcríbelo. Identifica frases que puedan simplificarse.',
                    ),
                    const Divider(),
                    _PracticeExercise(
                      title: 'Ejercicio de storytelling',
                      description:
                          'Practica tu pitch como si fuera una historia: ¿Quién es tu protagonista? ¿Cuál es el conflicto?',
                    ),
                    const Divider(),
                    _PracticeExercise(
                      title: 'Ejercicio de pausas',
                      description:
                          'Practica tu pitch añadiendo pausas de 2 segundos después de cada idea principal.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Retos diarios
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Reto diario',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reto de hoy',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Graba un pitch de 2 minutos sobre un tema que domines. Enfócate en mantener un ritmo constante y eliminar muletillas.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<_TipItem> tips;

  const _SectionCard({required this.title, required this.tips});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...tips.map(
              (tip) => Column(
                children: [tip, if (tip != tips.last) const Divider()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TipItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PracticeExercise extends StatelessWidget {
  final String title;
  final String description;

  const _PracticeExercise({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(description, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
