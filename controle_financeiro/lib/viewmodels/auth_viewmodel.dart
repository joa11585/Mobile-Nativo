import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';

class AuthViewModel extends ChangeNotifier {
  Usuario? usuarioLogado;

  Future<bool> login(String email, String senha) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('usuarios', where: 'email = ? AND senha = ?', whereArgs: [email, senha]);
    
    if (result.isNotEmpty) {
      usuarioLogado = Usuario.fromMap(result.first);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> cadastrar(Usuario usuario) async {
    final db = await DatabaseHelper.instance.database;
    try {
      await db.insert('usuarios', usuario.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    usuarioLogado = null;
    notifyListeners();
  }
}