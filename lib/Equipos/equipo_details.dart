// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:lab14/Equipos/equipo.dart';
import 'package:lab14/Equipos/equipo_db.dart'; 

class NoteDetailsView extends StatefulWidget {
  const NoteDetailsView({Key? key, this.noteId});
  final int? noteId;

  @override
  State<NoteDetailsView> createState() => _NoteDetailsViewState();
}

class _NoteDetailsViewState extends State<NoteDetailsView> {
  EquipoDatabase equipoDatabase = EquipoDatabase.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController foundingYearController = TextEditingController();

  late Equipo equipo;
  bool isLoading = false;
  bool isNewEquipo = false;
  bool isFavorite = false;

  @override
  void initState() {
    refreshEquipo();
    super.initState();
  }


  void refreshEquipo() {
    if (widget.noteId == null) {
      setState(() {
        isNewEquipo = true;
      });
      return;
    }
    equipoDatabase.read(widget.noteId!).then((value) {
      setState(() {
        equipo = value;
        nameController.text = equipo.name;
        foundingYearController.text = equipo.foundingYear.toString();
   
        isFavorite = false; 
      });
    });
  }


  void createEquipo() {
    setState(() {
      isLoading = true;
    });

    final model = Equipo(
      name: nameController.text,
      foundingYear: int.parse(foundingYearController.text),
      lastChampionshipDate: DateTime.now(),
    );

    if (isNewEquipo) {
      equipoDatabase.create(model);
    } else {
      model.id = equipo.id;
      equipoDatabase.update(model);
    }

    setState(() {
      isLoading = false;
    });
  }


  void deleteEquipo() {
    equipoDatabase.delete(equipo.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(!isFavorite ? Icons.favorite_border : Icons.favorite),
          ),
          Visibility(
            visible: !isNewEquipo,
            child: IconButton(
              onPressed: deleteEquipo,
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            onPressed: createEquipo,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    TextField(
                      controller: nameController,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: foundingYearController,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Founding Year',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
