import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Registrar novo usuário
  static Future<bool> cadastrarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) async {
    try {
      // Criar usuário no Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Salvar dados no Firestore
      await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'nome': nome,
        'email': email,
        'dataCriacao': DateTime.now().toIso8601String(),
      });

      return true;
    } on FirebaseAuthException catch (e) {
      print('Erro ao cadastrar: ${e.message}');
      return false;
    } catch (e) {
      print('Erro inesperado: $e');
      return false;
    }
  }

  /// Login do usuário
  static Future<bool> login({
    required String email,
    required String senha,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print('Erro ao fazer login: ${e.message}');
      return false;
    }
  }

  /// Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }

  /// Obter usuário atual
  static User? get usuarioAtual => _auth.currentUser;

  /// Obter stream de autenticação
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Adicionar transação no Firestore
  static Future<bool> adicionarTransacao({
    required String usuarioId,
    required String titulo,
    required double valor,
    required String data,
    required String tipo,
    required String categoria,
  }) async {
    try {
      await _firestore.collection('transacoes').add({
        'usuarioId': usuarioId,
        'titulo': titulo,
        'valor': valor,
        'data': data,
        'tipo': tipo,
        'categoria': categoria,
        'dataCriacao': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Erro ao adicionar transação: $e');
      return false;
    }
  }

  /// Obter stream de transações do usuário
  static Stream<QuerySnapshot> getTransacoesStream(String usuarioId) {
    return _firestore
        .collection('transacoes')
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('data', descending: true)
        .snapshots();
  }

  /// Atualizar transação
  static Future<bool> atualizarTransacao({
    required String docId,
    required String titulo,
    required double valor,
    required String tipo,
    required String categoria,
  }) async {
    try {
      await _firestore.collection('transacoes').doc(docId).update({
        'titulo': titulo,
        'valor': valor,
        'tipo': tipo,
        'categoria': categoria,
      });
      return true;
    } catch (e) {
      print('Erro ao atualizar transação: $e');
      return false;
    }
  }

  /// Deletar transação
  static Future<bool> deletarTransacao(String docId) async {
    try {
      await _firestore.collection('transacoes').doc(docId).delete();
      return true;
    } catch (e) {
      print('Erro ao deletar transação: $e');
      return false;
    }
  }

  /// Verificar se e-mail existe
  static Future<bool> emailJaExiste(String email) async {
    try {
      final resultado = await _firestore
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .get();
      return resultado.docs.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar e-mail: $e');
      return false;
    }
  }
}
