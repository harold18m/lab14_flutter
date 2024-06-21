// ignore: file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab14/Equipos/equipo.dart';
import 'package:lab14/Equipos/equipo_db.dart';
import 'package:lab14/Equipos/equipo_form_view.dart';

class EquipoView extends StatefulWidget {
  const EquipoView({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ID: ${equipo.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteEquipo(equipo.id!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text('Nombre: ${equipo.name}'),
                  const SizedBox(height: 8.0),
                  Text('Año de Fundación: ${equipo.foundingYear}'),
                  const SizedBox(height: 8.0),
                  Text(
                      'Última Fecha de Campeonato: ${DateFormat('yyyy-MM-dd').format(equipo.lastChampionshipDate)}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
