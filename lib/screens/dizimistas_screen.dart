import 'package:flutter/material.dart';
import '../models/dizimista.dart';

class DizimistasScreen extends StatelessWidget {
  final List<Dizimista> dizimistas;

  DizimistasScreen({required this.dizimistas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dizimistas')),
      body: ListView.builder(
        itemCount: dizimistas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dizimistas[index].nome),
            subtitle: Text(dizimistas[index].telefone),
          );
        },
      ),
    );
  }
}
