import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/dizimista.dart';

class CadastroDizimistaScreen extends StatefulWidget {
  @override
  _CadastroDizimistaScreenState createState() => _CadastroDizimistaScreenState();
}

class _CadastroDizimistaScreenState extends State<CadastroDizimistaScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  final enderecoController = TextEditingController();
  String sexo = 'Masculino';
  String statusRelacionamento = 'Solteiro';

  void cadastrarDizimista() {
    if (_formKey.currentState!.validate()) {
      final dizimista = Dizimista(
        nome: nomeController.text,
        telefone: telefoneController.text,
        dataNascimento: DateTime.parse(dataNascimentoController.text),
        endereco: enderecoController.text,
        sexo: sexo,
        statusRelacionamento: statusRelacionamento,
      );

      apiService.cadastrarDizimista(dizimista).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Dizimista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!.isEmpty) return 'Digite o nome';
                  return null;
                },
              ),
              TextFormField(
                controller: telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value!.isEmpty) return 'Digite o telefone';
                  return null;
                },
              ),
              TextFormField(
                controller: dataNascimentoController,
                decoration: InputDecoration(labelText: 'Data de Nascimento (YYYY-MM-DD)'),
                validator: (value) {
                  if (value!.isEmpty) return 'Digite a data de nascimento';
                  return null;
                },
              ),
              TextFormField(
                controller: enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
                validator: (value) {
                  if (value!.isEmpty) return 'Digite o endereço';
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: sexo,
                items: ['Masculino', 'Feminino']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    sexo = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Sexo'),
              ),
              DropdownButtonFormField(
                value: statusRelacionamento,
                items: ['Solteiro', 'Casado', 'Divorciado']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    statusRelacionamento = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Status de Relacionamento'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: cadastrarDizimista,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
