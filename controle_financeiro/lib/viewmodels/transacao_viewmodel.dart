import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transacao.dart';

class TransacaoViewModel extends ChangeNotifier {
  List<Transacao> transacoes = [];
  bool isLoading = false;

  double get saldoTotal {
    double total = 0;
    for (var t in transacoes) {
      total += (t.tipo == 'receita') ? t.valor : -t.valor;
    }
    return total;
  }

  double get totalReceitas {
    return transacoes
        .where((t) => t.tipo == 'receita')
        .fold(0.0, (sum, t) => sum + t.valor);
  }

  double get totalDespesas {
    return transacoes
        .where((t) => t.tipo == 'despesa')
        .fold(0.0, (sum, t) => sum + t.valor);
  }

  Future<void> carregarTransacoes({int? usuarioId}) async {
    isLoading = true;
    notifyListeners();
    
    try {
      final db = await DatabaseHelper.instance.database;
      List<Map<String, dynamic>> result;
      
      if (usuarioId != null) {
        result = await db.query(
          'transacoes',
          where: 'usuario_id = ?',
          whereArgs: [usuarioId],
          orderBy: 'data DESC',
        );
      } else {
        result = await db.query('transacoes', orderBy: 'data DESC');
      }
      
      transacoes = result.map((map) => Transacao.fromMap(map)).toList();
    } catch (e) {
      print('Erro ao carregar transações: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> adicionarTransacao(Transacao transacao) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert('transacoes', transacao.toMap());
      await carregarTransacoes(usuarioId: transacao.usuarioId);
      return true;
    } catch (e) {
      print('Erro ao adicionar transação: $e');
      return false;
    }
  }

  Future<bool> atualizarTransacao(Transacao transacao) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'transacoes',
        transacao.toMap(),
        where: 'id = ?',
        whereArgs: [transacao.id],
      );
      await carregarTransacoes(usuarioId: transacao.usuarioId);
      return true;
    } catch (e) {
      print('Erro ao atualizar transação: $e');
      return false;
    }
  }

  Future<bool> removerTransacao(int id, {int? usuarioId}) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('transacoes', where: 'id = ?', whereArgs: [id]);
      await carregarTransacoes(usuarioId: usuarioId);
      return true;
    } catch (e) {
      print('Erro ao remover transação: $e');
      return false;
    }
  }

  List<Transacao> filtrarPorTipo(String tipo) {
    return transacoes.where((t) => t.tipo == tipo).toList();
  }

  List<Transacao> filtrarPorCategoria(String categoria) {
    return transacoes.where((t) => t.categoria == categoria).toList();
  }

  List<String> get categoriasUnicas {
    final categorias = transacoes
        .where((t) => t.categoria != null && t.categoria!.isNotEmpty)
        .map((t) => t.categoria!)
        .toSet()
        .toList();
    categorias.sort();
    return categorias;
  }
}
