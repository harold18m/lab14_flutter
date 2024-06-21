import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab14/Equipos/equipo.dart';
import 'package:lab14/Equipos/equipo_db.dart';
import 'package:lab14/Equipos/equipo_form_view.dart';

class EquipoView extends StatefulWidget {
  const EquipoView({super.key});

  @override
  _EquipoViewState createState() => _EquipoViewState();
}

class _EquipoViewState extends State<EquipoView> {
  EquipoDatabase equipoDatabase = EquipoDatabase.instance;
  List<Equipo> equipos = [];

  @override
  void initState() {
    refreshEquipoList();
    super.initState();
  }

  void refreshEquipoList() {
    equipoDatabase.readAll().then((list) {
      setState(() {
        equipos = list;
      });
    });
  }

  void navigateToDetailsView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EquipoView2()),
    ).then((_) {
      refreshEquipoList();
    });
  }

  void deleteEquipo(int id) {
    equipoDatabase.delete(id).then((_) {
      refreshEquipoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipos'),
        backgroundColor: Colors.blueAccent, // Color actualizado
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              navigateToDetailsView(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: equipos.length,
        itemBuilder: (context, index) {
          Equipo equipo = equipos[index];
          return Card(
            elevation: 2.0, // Sombra más suave
            margin: const EdgeInsets.only(bottom: 16.0), // Margen entre tarjetas
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Equipo: ${equipo.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), 
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red), // Icono de color actualizado
                        onPressed: () => deleteEquipo(equipo.id!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  const SizedBox(height: 8.0),
                  Text('Año de Fundación: ${equipo.foundingYear}', style: TextStyle(color: Colors.grey[600])), // Texto actualizado
                  const SizedBox(height: 8.0),
                  Text(
                    'Última Fecha de Campeonato: ${DateFormat('yyyy-MM-dd').format(equipo.lastChampionshipDate)}',
                    style: TextStyle(color: Colors.grey[600]), // Texto actualizado
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}