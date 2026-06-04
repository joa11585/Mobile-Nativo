import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';

class AuthViewModel extends ChangeNotifier {
  Usuario? usuarioLogado;
  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String email, String senha) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Validação básica
      if (email.isEmpty || senha.isEmpty) {
        errorMessage = 'E-mail e senha são obrigatórios';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'usuarios',
        where: 'email = ? AND senha = ?',
        whereArgs: [email, senha],
      );

      if (result.isNotEmpty) {
        usuarioLogado = Usuario.fromMap(result.first);
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = 'E-mail ou senha incorretos';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'Erro ao fazer login: $e';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cadastrar(Usuario usuario) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Validação básica
      if (usuario.nome.isEmpty || usuario.email.isEmpty || usuario.senha.isEmpty) {
        errorMessage = 'Todos os campos são obrigatórios';
        isLoading = false;
        notifyListeners();
        return false;
      }

      if (!usuario.email.contains('@')) {
        errorMessage = 'E-mail inválido';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final db = await DatabaseHelper.instance.database;
      
      // Verificar se e-mail já existe
      final existing = await db.query(
        'usuarios',
        where: 'email = ?',
        whereArgs: [usuario.email],
      );

      if (existing.isNotEmpty) {
        errorMessage = 'E-mail já cadastrado';
        isLoading = false;
        notifyListeners();
        return false;
      }

      await db.insert('usuarios', usuario.toMap());
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Erro ao cadastrar: $e';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    usuarioLogado = null;
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }

  bool get estaLogado => usuarioLogado != null;
}
