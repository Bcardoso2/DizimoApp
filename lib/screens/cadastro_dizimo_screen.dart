import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../services/api_service.dart';
import '../models/dizimo.dart';
import '../models/dizimista.dart';

class CadastroDizimoScreen extends StatefulWidget {
  @override
  _CadastroDizimoScreenState createState() => _CadastroDizimoScreenState();
}

class _CadastroDizimoScreenState extends State<CadastroDizimoScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final valorController = TextEditingController();
  final descricaoController = TextEditingController();
  final dataController = TextEditingController();
  final dizimistaController = TextEditingController();
  
  List<Dizimista> dizimistas = [];
  List<Dizimista> filteredDizimistas = [];
  Dizimista? selectedDizimista;

  final maskFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  @override
  void initState() {
    super.initState();
    _fetchDizimistas();
  }

  void _fetchDizimistas() async {
    try {
      dizimistas = await apiService.listarDizimistas();
      setState(() {
        filteredDizimistas = dizimistas; // Inicia com todos os dizimistas
      });
    } catch (e) {
      print('Erro ao carregar dizimistas: $e');
    }
  }

  void buscarDizimistas(String nome) {
    if (nome.isEmpty) {
      setState(() {
        filteredDizimistas = dizimistas; // Mostra todos se o campo estiver vazio
      });
      return;
    }

    final filtered = dizimistas.where((dizimista) {
      return dizimista.nome.toLowerCase().contains(nome.toLowerCase());
    }).toList();

    setState(() {
      filteredDizimistas = filtered;
      selectedDizimista = filtered.isNotEmpty ? filtered.first : null;
    });
  }

  void cadastrarDizimo() {
  if (_formKey.currentState!.validate() && selectedDizimista != null) {
    final partesData = dataController.text.split('-');
    final data = DateTime(
      int.parse(partesData[2]),
      int.parse(partesData[1]),
      int.parse(partesData[0]),
    );

    final dizimo = Dizimo(
      dizimistaId: selectedDizimista!.id!,
      valor: double.tryParse(valorController.text.replaceAll(',', '.')) ?? 0.0,
      descricao: descricaoController.text,
      data: data,
      dizimistaNome: selectedDizimista!.nome, // Passando o nome do dizimista
    );

    apiService.cadastrarDizimo(dizimo).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dízimo cadastrado com sucesso!')));
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $error')));
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selecione um dizimista!')));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Dízimo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: dizimistaController,
                decoration: InputDecoration(labelText: 'Dizimista'),
                onChanged: buscarDizimistas,
              ),
              if (filteredDizimistas.isNotEmpty) // Exibe a lista se houver resultados
                Container(
                  height: 100,
                  child: ListView.builder(
                    itemCount: filteredDizimistas.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredDizimistas[index].nome),
                        onTap: () {
                          setState(() {
                            selectedDizimista = filteredDizimistas[index];
                            dizimistaController.text = selectedDizimista!.nome; // Preenche o campo de texto
                            filteredDizimistas.clear(); // Limpa a lista filtrada
                          });
                        },
                      );
                    },
                  ),
                ),
              if (filteredDizimistas.isEmpty && dizimistaController.text.isNotEmpty)
                Text('Nenhum dizimista encontrado', style: TextStyle(color: Colors.red)), // Mensagem de erro
              TextFormField(
                controller: valorController,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value!.isEmpty) return 'Digite o valor do dízimo';
                  return null;
                },
              ),
              TextFormField(
                controller: descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value!.isEmpty) return 'Digite uma descrição';
                  return null;
                },
              ),
              TextFormField(
                controller: dataController,
                decoration: InputDecoration(
                  labelText: 'Data (DD-MM-AAAA)',
                ),
                inputFormatters: [maskFormatter],
                validator: (value) {
                  if (value!.isEmpty || value.length < 10) return 'Digite uma data válida';
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: cadastrarDizimo,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
