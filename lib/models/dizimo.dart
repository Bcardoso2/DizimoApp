class Dizimo {
  final int? id;
  final int dizimistaId; // Não pode ser nulo, já que é um ID obrigatório
  final double valor; // Não pode ser nulo, sempre deve ter um valor
  final DateTime data;
  final String descricao;
  final String dizimistaNome;

  Dizimo({
    this.id,
    required this.dizimistaId,
    required this.valor,
    required this.data,
    required this.descricao,
    required this.dizimistaNome,
  });

  factory Dizimo.fromJson(Map<String, dynamic> json) {
    return Dizimo(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      dizimistaId: int.tryParse(json['dizimista_id'].toString()) ?? 0, // Padrão para 0 se não puder converter
      valor: double.tryParse(json['valor'].toString()) ?? 0.0, // Padrão para 0.0 se não puder converter
      data: DateTime.parse(json['data']),
      descricao: json['descricao'] ?? '', // Padrão para string vazia se for nulo
      dizimistaNome: json['dizimista_nome'] ?? '', // Padrão para string vazia se for nulo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dizimista_id': dizimistaId,
      'valor': valor.toString(),
      'data': data.toIso8601String(),
      'descricao': descricao,
      'dizimista_nome': dizimistaNome,
    };
  }
}
