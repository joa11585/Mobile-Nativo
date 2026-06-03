class Transacao {
  int? id;
  String titulo;
  double valor;
  String data;
  String tipo; // 'receita' ou 'despesa'

  Transacao({this.id, required this.titulo, required this.valor, required this.data, required this.tipo});

  Map<String, dynamic> toMap() {
    return {'id': id, 'titulo': titulo, 'valor': valor, 'data': data, 'tipo': tipo};
  }

  factory Transacao.fromMap(Map<String, dynamic> map) {
    return Transacao(id: map['id'], titulo: map['titulo'], valor: map['valor'], data: map['data'], tipo: map['tipo']);
  }
}