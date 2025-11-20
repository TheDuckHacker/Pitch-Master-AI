import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pitchmaster_ai/main.dart';
import 'package:pitchmaster_ai/services/app_provider.dart';
import 'package:pitchmaster_ai/screens/welcome_screen.dart';
import 'package:pitchmaster_ai/screens/home_screen.dart';
import 'package:pitchmaster_ai/screens/education_screen.dart';
import 'package:pitchmaster_ai/screens/progress_screen.dart';
import 'package:pitchmaster_ai/screens/analysis_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Helper para crear la app con provider
  Widget createTestApp(Widget home) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        home: home,
        routes: {
          '/home': (context) => const HomeScreen(),
          '/welcome': (context) => const WelcomeScreen(),
        },
      ),
    );
  }

  group('WelcomeScreen Tests', () {
    testWidgets('Muestra el título PitchMaster AI', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(const WelcomeScreen()));

      expect(find.text('PitchMaster AI'), findsOneWidget);
      expect(
        find.text('Mejora tu comunicación con análisis inteligente'),
        findsOneWidget,
      );
    });

    testWidgets('Muestra las características principales', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(const WelcomeScreen()));

      expect(find.text('Análisis detallado'), findsOneWidget);
      expect(find.text('Detección de emociones'), findsOneWidget);
      expect(find.text('Sigue tu progreso'), findsOneWidget);
    });

    testWidgets('Muestra el botón Empezar', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const WelcomeScreen()));

      expect(find.text('Empezar'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Navega a HomeScreen al presionar Empezar', (
      WidgetTester tester,
    ) async {
      // Limpiar SharedPreferences para el test
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(createTestApp(const WelcomeScreen()));

      // Buscar y presionar el botón
      final button = find.text('Empezar');
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Verificar que navegó a HomeScreen
      expect(find.text('PitchMaster AI'), findsOneWidget);
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });

  group('HomeScreen Tests', () {
    testWidgets('Muestra la barra de navegación inferior', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(const HomeScreen()));

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Grabar'), findsOneWidget);
      expect(find.text('Progreso'), findsOneWidget);
      expect(find.text('Aprender'), findsOneWidget);
      expect(find.text('Config'), findsOneWidget);
    });

    testWidgets('Muestra botones de grabación y subida', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(const HomeScreen()));

      expect(find.text('Iniciar grabación'), findsOneWidget);
      expect(find.text('Subir archivo de audio'), findsOneWidget);
    });

    testWidgets('Navega entre pestañas', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const HomeScreen()));

      // Ir a la pestaña de Progreso
      await tester.tap(find.text('Progreso'));
      await tester.pumpAndSettle();

      expect(find.text('Mi Progreso'), findsOneWidget);

      // Ir a la pestaña de Aprender
      await tester.tap(find.text('Aprender'));
      await tester.pumpAndSettle();

      expect(find.text('Aprende'), findsOneWidget);
    });
  });

  group('EducationScreen Tests', () {
    testWidgets('Muestra todas las secciones educativas', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(const EducationScreen()));

      expect(find.text('Comunicación efectiva'), findsOneWidget);
      expect(find.text('Storytelling'), findsOneWidget);
      expect(find.text('Manejo de muletillas'), findsOneWidget);
      expect(find.text('Técnicas de respiración'), findsOneWidget);
      expect(find.text('Control emocional'), findsOneWidget);
    });

    testWidgets('Muestra tips específicos', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const EducationScreen()));

      expect(find.text('Máximo 12 segundos por idea'), findsOneWidget);
      expect(find.text('Evita tecnicismos innecesarios'), findsOneWidget);
      expect(find.text('Comienza con el problema'), findsOneWidget);
    });

    testWidgets('Muestra ejercicios prácticos', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const EducationScreen()));

      expect(find.text('Ejercicios prácticos'), findsOneWidget);
      expect(find.text('Ejercicio de velocidad'), findsOneWidget);
      expect(find.text('Ejercicio de claridad'), findsOneWidget);
    });

    testWidgets('Muestra reto diario', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const EducationScreen()));

      expect(find.text('Reto diario'), findsOneWidget);
      expect(find.text('Reto de hoy'), findsOneWidget);
    });
  });

  group('ProgressScreen Tests', () {
    testWidgets('Muestra el nivel actual', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const ProgressScreen()));

      expect(find.text('Mi Progreso'), findsOneWidget);
      expect(find.text('Nivel actual'), findsOneWidget);
      expect(find.text('Pitch básico'), findsOneWidget);
    });

    testWidgets('Muestra estadísticas', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const ProgressScreen()));

      expect(find.text('Estadísticas'), findsOneWidget);
      expect(find.text('Pitches analizados'), findsOneWidget);
      expect(find.text('Score promedio'), findsOneWidget);
      expect(find.text('Racha'), findsOneWidget);
      expect(find.text('Logros'), findsOneWidget);
    });

    testWidgets('Muestra mensaje cuando no hay logros', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(const ProgressScreen()));

      expect(find.text('Aún no has desbloqueado logros'), findsOneWidget);
    });
  });

  group('AnalysisScreen Tests', () {
    testWidgets('Muestra mensaje cuando no hay análisis', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestApp(const AnalysisScreen()));

      expect(find.text('Análisis'), findsOneWidget);
      expect(find.text('No hay análisis disponible'), findsOneWidget);
    });
  });

  group('App Integration Tests', () {
    testWidgets('La app inicia correctamente', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(const PitchMasterApp());
      await tester.pumpAndSettle();

      // Debería mostrar la pantalla de bienvenida o home según preferencias
      final welcomeScreen = find.byType(WelcomeScreen);
      final homeScreen = find.byType(HomeScreen);

      // Verificar que al menos una de las pantallas está presente
      final hasWelcome = tester.widgetList(welcomeScreen).isNotEmpty;
      final hasHome = tester.widgetList(homeScreen).isNotEmpty;
      expect(hasWelcome || hasHome, isTrue);
    });

    testWidgets('Navegación completa entre pantallas', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({'has_seen_welcome': true});

      await tester.pumpWidget(const PitchMasterApp());
      await tester.pumpAndSettle();

      // Debería estar en HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);

      // Navegar a Progreso
      await tester.tap(find.text('Progreso'));
      await tester.pumpAndSettle();
      expect(find.text('Mi Progreso'), findsOneWidget);

      // Navegar a Aprender
      await tester.tap(find.text('Aprender'));
      await tester.pumpAndSettle();
      expect(find.text('Aprende'), findsOneWidget);

      // Volver a Grabar
      await tester.tap(find.text('Grabar'));
      await tester.pumpAndSettle();
      expect(find.text('Mejora tu Pitch'), findsOneWidget);
    });
  });
}
