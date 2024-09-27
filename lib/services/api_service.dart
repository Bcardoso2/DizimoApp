import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dizimo.dart';
import '../models/dizimista.dart';

class ApiService {
  final String baseUrl = 'https://briciocardoso.com/dizimo/api'; // ajuste aqui

  Future<List<Dizimista>> listarDizimistas() async {
    final response = await http.get(Uri.parse('$baseUrl/listar_dizimistas.php'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Dizimista.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar dizimistas');
    }
  }

  Future<void> cadastrarDizimista(Dizimista dizimista) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cadastrar_dizimista.php'),
      body: {
        'nome': dizimista.nome,
        'telefone': dizimista.telefone,
        'data_nascimento': dizimista.dataNascimento.toIso8601String(),
        'endereco': dizimista.endereco,
        'sexo': dizimista.sexo,
        'status_relacionamento': dizimista.statusRelacionamento,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao cadastrar dizimista');
    }
  }

  Future<void> cadastrarDizimo(Dizimo dizimo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registrar_dizimo.php'),
      body: {
        'dizimista_id': dizimo.dizimistaId.toString(),
        'valor': dizimo.valor.toString(),
        'data': dizimo.data.toIso8601String(),
        'descricao': dizimo.descricao,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao cadastrar dízimo: ${response.body}');
    }
  }

  Future<List<Dizimo>> listarUltimosDizimos() async {
    final response = await http.get(Uri.parse('$baseUrl/listar_ultimos_dizimos.php'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Dizimo.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar últimos dízimos');
    }
  }

  // Implementações para buscar depósitos
  Future<List<Dizimo>> listarDepositosDiarios() async {
    final response = await http.get(Uri.parse('$baseUrl/listar_depositos_diarios.php'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Dizimo.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar depósitos diários');
    }
  }

  Future<List<Dizimo>> listarDepositosMensais() async {
    final response = await http.get(Uri.parse('$baseUrl/listar_depositos_mensais.php'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Dizimo.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar depósitos mensais');
    }
  }

  Future<List<Dizimo>> listarDepositosTodos() async {
  final response = await http.get(Uri.parse('$baseUrl/listar_depositos_todos.php'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((json) => Dizimo.fromJson(json)).toList();
  } else {
    throw Exception('Falha ao carregar todos os depósitos');
  }
}

}
