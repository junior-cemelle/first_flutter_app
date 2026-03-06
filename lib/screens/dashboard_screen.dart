import 'package:dmsn2026/database/cast_db.dart';
import 'package:dmsn2026/listeners/value_listener.dart'; // para el toggle de tema
import 'package:dmsn2026/models/cast_model.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  CastDB? castDB;
  late Future<List<CastDAO>> _futureData;

  @override
  void initState() {
    super.initState();
    castDB = CastDB();
    _futureData = _loadData();
  }

  Future<List<CastDAO>> _loadData() async {
    try {
      final result = await castDB!.selectAll();
      debugPrint("✅ Conexión exitosa. Registros obtenidos: ${result.length}");
      return result;
    } catch (e) {
      debugPrint("❌ Error al conectar o hacer SELECT: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          // --- Botón toggle de tema claro/oscuro ---
          ValueListenableBuilder<bool>(
            valueListenable: ValueListener.isDarkMode,
            builder: (context, isDark, _) {
              return IconButton(
                tooltip: isDark ? "Cambiar a tema claro" : "Cambiar a tema oscuro",
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  // Alterna el valor del ValueNotifier — main.dart reacciona automáticamente
                  ValueListener.isDarkMode.value = !isDark;
                },
              );
            },
          ),
          // --- Botón para abrir la pantalla de perfiles/actores ---
          IconButton(
            tooltip: "Ver actores",
            icon: const Icon(Icons.people),
            onPressed: () => Navigator.pushNamed(context, "/cast"),
          ),
        ],
      ),
      body: FutureBuilder<List<CastDAO>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    "❌ Error al conectar a la base de datos",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final list = snapshot.data!;
            return Column(
              children: [
                // Banner de estado de conexión
                Container(
                  width: double.infinity,
                  color: Colors.green.shade100,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        "✅ Conexión exitosa — ${list.length} registro(s) encontrado(s)",
                        style: TextStyle(color: Colors.green.shade800),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: list.isEmpty
                      ? const Center(child: Text("No hay actores registrados."))
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final cast = list[index];
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(cast.nameCast ?? "Sin nombre"),
                              subtitle: Text(
                                "Nacimiento: ${cast.bitrhCast ?? '-'} | Género: ${cast.genderCast ?? '-'}",
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
