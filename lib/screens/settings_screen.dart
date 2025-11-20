import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Configuración'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Tema
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        appProvider.isDarkTheme
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('Tema'),
                      subtitle: Text(
                        appProvider.isDarkTheme ? 'Oscuro' : 'Claro',
                      ),
                      trailing: Switch(
                        value: appProvider.isDarkTheme,
                        onChanged: (value) {
                          appProvider.toggleTheme();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Mostrar/Ocultar historial
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.history,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('Mostrar historial'),
                      subtitle: const Text(
                        'Mostrar el historial de análisis en la pantalla de progreso',
                      ),
                      trailing: FutureBuilder<bool>(
                        future: appProvider.getShowHistory(),
                        builder: (context, snapshot) {
                          final showHistory = snapshot.data ?? true;
                          return Switch(
                            value: showHistory,
                            onChanged: (value) async {
                              await appProvider.setShowHistory(value);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Mostrar/Ocultar comparaciones
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.compare_arrows,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text('Mostrar comparaciones'),
                      subtitle: const Text(
                        'Mostrar comparaciones entre diferentes versiones de tu pitch',
                      ),
                      trailing: FutureBuilder<bool>(
                        future: appProvider.getShowComparisons(),
                        builder: (context, snapshot) {
                          final showComparisons = snapshot.data ?? true;
                          return Switch(
                            value: showComparisons,
                            onChanged: (value) async {
                              await appProvider.setShowComparisons(value);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Limpiar datos
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      title: const Text('Eliminar historial'),
                      subtitle: const Text(
                        'Eliminar todos los análisis guardados',
                      ),
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar eliminación'),
                            content: const Text(
                              '¿Estás seguro de que quieres eliminar todo el historial? Esta acción no se puede deshacer.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).colorScheme.error,
                                ),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          await appProvider.clearAllAnalyses();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Historial eliminado'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.refresh,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      title: const Text('Restablecer todo'),
                      subtitle: const Text(
                        'Eliminar todos los datos y configuraciones',
                      ),
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar restablecimiento'),
                            content: const Text(
                              '¿Estás seguro de que quieres restablecer toda la aplicación? Esto eliminará todos tus datos y configuraciones. Esta acción no se puede deshacer.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).colorScheme.error,
                                ),
                                child: const Text('Restablecer'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          await appProvider.resetAll();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Aplicación restablecida'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Información de la app
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Acerca de',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.info_outline),
                        title: const Text('Versión'),
                        trailing: const Text('1.0.0'),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.code),
                        title: const Text('Desarrollado con Flutter'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

