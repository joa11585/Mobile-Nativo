import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NoticiaViewModel extends ChangeNotifier {
  List<Noticia> _noticias = [];
  List<Noticia> _noticiasCripto = [];
  List<Noticia> _noticiasAcoes = [];
  bool _isLoading = false;
  String _erro = '';

  List<Noticia> get noticias => _noticias;
  List<Noticia> get noticiasCripto => _noticiasCripto;
  List<Noticia> get noticiasAcoes => _noticiasAcoes;
  bool get isLoading => _isLoading;
  String get erro => _erro;

  /// Carregar notícias financeiras gerais
  Future<void> carregarNoticias() async {
    _isLoading = true;
    _erro = '';
    notifyListeners();

    try {
      _noticias = await APIService.obterNoticiasFinanceiras();
      if (_noticias.isEmpty) {
        _erro = 'Nenhuma notícia encontrada';
      }
    } catch (e) {
      _erro = 'Erro ao carregar notícias: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carregar notícias de criptomoedas
  Future<void> carregarNoticiasCripto() async {
    _isLoading = true;
    _erro = '';
    notifyListeners();

    try {
      _noticiasCripto = await APIService.obterNoticiasCripto();
      if (_noticiasCripto.isEmpty) {
        _erro = 'Nenhuma notícia de cripto encontrada';
      }
    } catch (e) {
      _erro = 'Erro ao carregar notícias de cripto: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carregar notícias de ações
  Future<void> carregarNoticiasAcoes() async {
    _isLoading = true;
    _erro = '';
    notifyListeners();

    try {
      _noticiasAcoes = await APIService.obterNoticiasAcoes();
      if (_noticiasAcoes.isEmpty) {
        _erro = 'Nenhuma notícia de ações encontrada';
      }
    } catch (e) {
      _erro = 'Erro ao carregar notícias de ações: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carregar todas as notícias simultaneamente
  Future<void> carregarTodasNoticias() async {
    _isLoading = true;
    _erro = '';
    notifyListeners();

    try {
      await Future.wait([
        carregarNoticias(),
        carregarNoticiasCripto(),
        carregarNoticiasAcoes(),
      ]);
    } catch (e) {
      _erro = 'Erro ao carregar notícias: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
