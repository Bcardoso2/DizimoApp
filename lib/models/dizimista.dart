class Dizimista {
  final int? id; 
  final String nome;
  final String telefone;
  final DateTime dataNascimento;
  final String endereco;
  final String sexo;
  final String statusRelacionamento;

  Dizimista({
    this.id, 
    required this.nome,
    required this.telefone,
    required this.dataNascimento,
    required this.endereco,
    required this.sexo,
    required this.statusRelacionamento,
  });

  factory Dizimista.fromJson(Map<String, dynamic> json) {
    return Dizimista(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      nome: json['nome'],
      telefone: json['telefone'],
      dataNascimento: DateTime.parse(json['data_nascimento']),
      endereco: json['endereco'],
      sexo: json['sexo'],
      statusRelacionamento: json['status_relacionamento'],
    );
  }

  @override
  String toString() {
    return 'Dizimista{id: $id, nome: $nome, telefone: $telefone}'; // Customize conforme necessário
  }
}
