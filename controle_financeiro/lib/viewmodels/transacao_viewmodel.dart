import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transacao.dart';

class TransacaoViewModel extends ChangeNotifier {
  List<Transacao> transacoes = [];

  double get saldoTotal {
    double total = 0;
    for (var t in transacoes) {
      total += (t.tipo == 'receita') ? t.valor : -t.valor;
    }
    return total;
  }

  Future<void> carregarTransacoes() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('transacoes');
    transacoes = result.map((map) => Transacao.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> adicionarTransacao(Transacao transacao) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('transacoes', transacao.toMap());
    await carregarTransacoes();
  }

  Future<void> removerTransacao(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('transacoes', where: 'id = ?', whereArgs: [id]);
    await carregarTransacoes();
  }
}