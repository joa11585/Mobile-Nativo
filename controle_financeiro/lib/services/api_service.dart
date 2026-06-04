import 'package:http/http.dart' as http;
import 'dart:convert';

class Noticia {
  final String titulo;
  final String descricao;
  final String fonte;
  final String url;
  final String? imagem;
  final DateTime dataPub;

  Noticia({
    required this.titulo,
    required this.descricao,
    required this.fonte,
    required this.url,
    this.imagem,
    required this.dataPub,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      titulo: json['title'] ?? 'Sem título',
      descricao: json['description'] ?? json['summary'] ?? 'Sem descrição',
      fonte: json['source']['name'] ?? 'Fonte desconhecida',
      url: json['url'] ?? '',
      imagem: json['image'],
      dataPub: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class APIService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = 'demo'; // Use sua chave de NewsAPI

  /// Obter notícias financeiras
  static Future<List<Noticia>> obterNoticiasFinanceiras() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/everything'
          '?q=finance+OR+economy+OR+investimento+OR+mercado+OR+bitcoin'
          '&language=pt'
          '&sortBy=publishedAt'
          '&pageSize=10'
          '&apiKey=$_apiKey',
        ),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final articles = (json['articles'] as List)
            .map((article) => Noticia.fromJson(article))
            .toList();
        return articles;
      } else {
        print('Erro na API: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro ao buscar notícias: $e');
      return [];
    }
  }

  /// Obter notícias sobre criptomoedas
  static Future<List<Noticia>> obterNoticiasCripto() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/everything'
          '?q=cryptocurrency+OR+bitcoin+OR+ethereum'
          '&language=pt'
          '&sortBy=publishedAt'
          '&pageSize=10'
          '&apiKey=$_apiKey',
        ),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final articles = (json['articles'] as List)
            .map((article) => Noticia.fromJson(article))
            .toList();
        return articles;
      } else {
        return [];
      }
    } catch (e) {
      print('Erro ao buscar notícias de cripto: $e');
      return [];
    }
  }

  /// Obter notícias sobre mercado de ações
  static Future<List<Noticia>> obterNoticiasAcoes() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/everything'
          '?q=stock+market+OR+bolsa+OR+ações'
          '&language=pt'
          '&sortBy=publishedAt'
          '&pageSize=10'
          '&apiKey=$_apiKey',
        ),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final articles = (json['articles'] as List)
            .map((article) => Noticia.fromJson(article))
            .toList();
        return articles;
      } else {
        return [];
      }
    } catch (e) {
      print('Erro ao buscar notícias de ações: $e');
      return [];
    }
  }
}
