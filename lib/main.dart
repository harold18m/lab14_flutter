import 'package:flutter/material.dart';
import 'package:lab14/Equipos/equipo_view.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equipos Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EquipoView(), 
    );
  }
}