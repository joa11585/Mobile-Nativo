import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/noticia_viewmodel.dart';
import '../services/api_service.dart';

class NoticiasView extends StatefulWidget {
  @override
  State<NoticiasView> createState() => _NoticiasViewState();
}

class _NoticiasViewState extends State<NoticiasView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Carregar notícias ao iniciar
    Future.microtask(() {
      final viewModel = context.read<NoticiaViewModel>();
      viewModel.carregarTodasNoticias();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📰 Notícias Financeiras'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Geral'),
            Tab(text: 'Cripto'),
            Tab(text: 'Ações'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNoticiasList(context, 'geral'),
          _buildNoticiasList(context, 'cripto'),
          _buildNoticiasList(context, 'acoes'),
        ],
      ),
    );
  }

  Widget _buildNoticiasList(BuildContext context, String tipo) {
    return Consumer<NoticiaViewModel>(
      builder: (context, viewModel, child) {
        List<Noticia> noticias;
        
        if (tipo == 'geral') {
          noticias = viewModel.noticias;
        } else if (tipo == 'cripto') {
          noticias = viewModel.noticiasCripto;
        } else {
          noticias = viewModel.noticiasAcoes;
        }

        if (viewModel.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Carregando notícias...'),
              ],
            ),
          );
        }

        if (viewModel.erro.isNotEmpty && noticias.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(viewModel.erro),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    if (tipo == 'geral') {
                      viewModel.carregarNoticias();
                    } else if (tipo == 'cripto') {
                      viewModel.carregarNoticiasCripto();
                    } else {
                      viewModel.carregarNoticiasAcoes();
                    }
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        if (noticias.isEmpty) {
          return Center(
            child: Text('Nenhuma notícia disponível'),
          );
        }

        return RefreshIndicator(
          onRefresh: () {
            if (tipo == 'geral') {
              return viewModel.carregarNoticias();
            } else if (tipo == 'cripto') {
              return viewModel.carregarNoticiasCripto();
            } else {
              return viewModel.carregarNoticiasAcoes();
            }
          },
          child: ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: noticias.length,
            itemBuilder: (context, index) {
              final noticia = noticias[index];
              return _buildNoticiaCard(context, noticia);
            },
          ),
        );
      },
    );
  }

  Widget _buildNoticiaCard(BuildContext context, Noticia noticia) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Abrir notícia em navegador (implementar com url_launcher)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Abrindo: ${noticia.url}')),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            if (noticia.imagem != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Image.network(
                  noticia.imagem!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            // Conteúdo
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fonte e data
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          noticia.fonte,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatarData(noticia.dataPub),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Título
                  Text(
                    noticia.titulo,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  // Descrição
                  Text(
                    noticia.descricao,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  // Botão Ler Mais
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Abrindo notícia...')),
                        );
                      },
                      icon: Icon(Icons.open_in_new, size: 16),
                      label: Text('Ler Mais'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inHours < 1) {
      return 'há ${diferenca.inMinutes}m';
    } else if (diferenca.inHours < 24) {
      return 'há ${diferenca.inHours}h';
    } else if (diferenca.inDays < 7) {
      return 'há ${diferenca.inDays}d';
    } else {
      return '${data.day}/${data.month}/${data.year}';
    }
  }
}
