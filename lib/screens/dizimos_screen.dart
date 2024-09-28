import 'package:flutter/material.dart';
import '../models/dizimo.dart';
import 'cadastro_dizimo_screen.dart'; // Certifique-se de importar a tela correta

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CadastroDizimoScreen(), // Navegar para a tela de cadastro
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Adicionar Dízimo',
      ),
    );
  }
}
