class Transacao {
  int? id;
  int? usuarioId;
  String titulo;
  double valor;
  String data;
  String tipo; // 'receita' ou 'despesa'
  String? categoria;

  Transacao({
    this.id,
    this.usuarioId,
    required this.titulo,
    required this.valor,
    required this.data,
    required this.tipo,
    this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'titulo': titulo,
      'valor': valor,
      'data': data,
      'tipo': tipo,
      'categoria': categoria,
    };
  }

  factory Transacao.fromMap(Map<String, dynamic> map) {
    return Transacao(
      id: map['id'],
      usuarioId: map['usuario_id'],
      titulo: map['titulo'],
      valor: map['valor'],
      data: map['data'],
      tipo: map['tipo'],
      categoria: map['categoria'],
    );
  }

  /// Formata a data para exibição (DD/MM/YYYY)
  String get dataFormatada {
    try {
      final dateTime = DateTime.parse(data);
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    } catch (e) {
      return data;
    }
  }

  /// Retorna ícone baseado na categoria
  String get icone {
    switch (categoria?.toLowerCase()) {
      case 'alimentação':
        return '🍔';
      case 'transporte':
        return '🚗';
      case 'saúde':
        return '🏥';
      case 'educação':
        return '📚';
      case 'lazer':
        return '🎬';
      case 'salário':
        return '💰';
      case 'investimento':
        return '📈';
      case 'outros':
      default:
        return tipo == 'receita' ? '➕' : '➖';
    }
  }
}
