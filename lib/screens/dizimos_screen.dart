import 'package:flutter/material.dart';
import '../models/dizimo.dart';

class DizimosScreen extends StatelessWidget {
  final List<Dizimo> dizimos;

  DizimosScreen({required this.dizimos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dízimos')),
      body: ListView.builder(
        itemCount: dizimos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Valor: R\$ ${dizimos[index].valor}'),
            subtitle: Text('Data: ${dizimos[index].data.toLocal().toString().split(' ')[0]}'),
          );
        },
      ),
    );
  }
}
