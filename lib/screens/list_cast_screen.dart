import 'package:dmsn2026/database/cast_db.dart';
import 'package:dmsn2026/listeners/value_listener.dart';
import 'package:dmsn2026/models/cast_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListCastScreen extends StatefulWidget {
  const ListCastScreen({super.key});

  @override
  State<ListCastScreen> createState() => _ListCastScreenState();
}

class _ListCastScreenState extends State<ListCastScreen> {
  CastDB? castDB;

  final _nameController   = TextEditingController();
  final _birthController  = TextEditingController();
  final _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    castDB = CastDB();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<List<CastDAO>> _loadData() => castDB!.selectAll();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de actores"),
        actions: [
          IconButton(
            onPressed: _showForm,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: ValueListener.refreshList,
        builder: (context, value, child) {
          return FutureBuilder<List<CastDAO>>(
            future: _loadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (snapshot.hasData) {
                final list = snapshot.data!;
                if (list.isEmpty) {
                  return const Center(child: Text("No hay actores registrados."));
                }
                return ListView.builder(
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
                );
              }
              return const SizedBox();
            },
          );
        }
      ),
    );
  }

  void _showForm() {
    // Limpiar controllers antes de abrir
    _nameController.clear();
    _birthController.clear();
    _genderController.clear();

    showDialog(
      context: context,
      builder: (dialogContext) {
        // FIX: StatefulBuilder para poder refrescar la UI del diálogo (ej. campo de fecha)
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text("Agregar actor"),
              content: SizedBox(
                height: 240,
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // --- Nombre ---
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Nombre del actor",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // --- Fecha de nacimiento ---
                    // FIX: GestureDetector + AbsorbPointer reemplaza enabled:false + onTap
                    //      enabled:false bloquea onTap, por eso el DatePicker nunca abría
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: dialogContext,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          // FIX: asignar fecha al controller y refrescar el diálogo
                          setDialogState(() {
                            _birthController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _birthController,
                          decoration: const InputDecoration(
                            labelText: "Fecha de nacimiento",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // --- Género ---
                    TextFormField(
                      controller: _genderController,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        labelText: "Género (M/F)",
                        border: OutlineInputBorder(),
                        counterText: "", // oculta el contador de maxLength
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final data = {
                      "nameCast"  : _nameController.text.trim(),
                      "bitrhCast" : _birthController.text.trim(),
                      "genderCast": _genderController.text.trim(),
                    };

                    final result = await castDB!.insert(data);

                    if (!dialogContext.mounted) return;
                    Navigator.pop(dialogContext); // FIX: cerrar el diálogo siempre

                    // FIX: insert() devuelve el rowId insertado (>0 éxito, -1 error)
                    if (result > 0) {
                      setState(() {}); // refrescar FutureBuilder de la lista
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(" Registro guardado"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      ValueListener.refreshList.value = true;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(" Error al guardar"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
