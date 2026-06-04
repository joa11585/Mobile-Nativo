import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transacao.dart';
import '../viewmodels/transacao_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_view.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String _filtroSelecionado = 'todos';

  @override
  void initState() {
    super.initState();
    final usuarioId = Provider.of<AuthViewModel>(context, listen: false).usuarioLogado?.id;
    Provider.of<TransacaoViewModel>(context, listen: false).carregarTransacoes(usuarioId: usuarioId);
  }

  void _abrirModalAdicionarTransacao(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String titulo = '';
    double valor = 0.0;
    String tipo = 'despesa';
    String categoria = 'Outros';

    final categoriasPorTipo = {
      'despesa': ['Alimentação', 'Transporte', 'Saúde', 'Educação', 'Lazer', 'Outros'],
      'receita': ['Salário', 'Investimento', 'Freelance', 'Outros'],
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Adicionar Transação',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Título',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (value) => value!.isEmpty ? 'Obrigatório' : null,
                      onSaved: (value) => titulo = value!,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Valor',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value!.isEmpty) return 'Obrigatório';
                        if (double.tryParse(value) == null) return 'Valor inválido';
                        return null;
                      },
                      onSaved: (value) => valor = double.parse(value!),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: tipo,
                      decoration: InputDecoration(
                        labelText: 'Tipo',
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: ['receita', 'despesa'].map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text(t == 'receita' ? '➕ Receita' : '➖ Despesa'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setModalState(() {
                          tipo = val!;
                          categoria = categoriasPorTipo[tipo]![0];
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: categoria,
                      decoration: InputDecoration(
                        labelText: 'Categoria',
                        prefixIcon: Icon(Icons.tag),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: (categoriasPorTipo[tipo] ?? []).map((c) {
                        return DropdownMenuItem(value: c, child: Text(c));
                      }).toList(),
                      onChanged: (val) => setModalState(() => categoria = val!),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final usuarioId = Provider.of<AuthViewModel>(context, listen: false).usuarioLogado?.id;
                          final novaTransacao = Transacao(
                            titulo: titulo,
                            valor: valor,
                            data: DateTime.now().toString(),
                            tipo: tipo,
                            categoria: categoria,
                            usuarioId: usuarioId,
                          );
                          Provider.of<TransacaoViewModel>(context, listen: false).adicionarTransacao(novaTransacao);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Transação adicionada!'), backgroundColor: Colors.green),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        backgroundColor: Colors.blue[700],
                      ),
                      child: Text('Adicionar', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _editarTransacao(Transacao transacao) {
    final _formKey = GlobalKey<FormState>();
    String titulo = transacao.titulo;
    double valor = transacao.valor;
    String tipo = transacao.tipo;
    String categoria = transacao.categoria ?? 'Outros';

    final categoriasPorTipo = {
      'despesa': ['Alimentação', 'Transporte', 'Saúde', 'Educação', 'Lazer', 'Outros'],
      'receita': ['Salário', 'Investimento', 'Freelance', 'Outros'],
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Editar Transação',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: titulo,
                      decoration: InputDecoration(
                        labelText: 'Título',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (value) => value!.isEmpty ? 'Obrigatório' : null,
                      onSaved: (value) => titulo = value!,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: valor.toString(),
                      decoration: InputDecoration(
                        labelText: 'Valor',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value!.isEmpty) return 'Obrigatório';
                        if (double.tryParse(value) == null) return 'Valor inválido';
                        return null;
                      },
                      onSaved: (value) => valor = double.parse(value!),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: categoria,
                      decoration: InputDecoration(
                        labelText: 'Categoria',
                        prefixIcon: Icon(Icons.tag),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: (categoriasPorTipo[tipo] ?? []).map((c) {
                        return DropdownMenuItem(value: c, child: Text(c));
                      }).toList(),
                      onChanged: (val) => setModalState(() => categoria = val!),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                final transacaoAtualizada = Transacao(
                                  id: transacao.id,
                                  titulo: titulo,
                                  valor: valor,
                                  data: transacao.data,
                                  tipo: tipo,
                                  categoria: categoria,
                                  usuarioId: transacao.usuarioId,
                                );
                                Provider.of<TransacaoViewModel>(context, listen: false)
                                    .atualizarTransacao(transacaoAtualizada);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Transação atualizada!'), backgroundColor: Colors.green),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
                            child: Text('Salvar', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[400]),
                            child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Financeiro'),
        elevation: 0,
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authVM.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginView()));
            },
          ),
        ],
      ),
      body: Consumer<TransacaoViewModel>(
        builder: (context, transacaoVM, _) {
          return transacaoVM.isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Cards de Resumo
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Saldo Total
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue[700]!, Colors.blue[500]!],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Text(
                                    'Saldo Total',
                                    style: TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'R\$ ${transacaoVM.saldoTotal.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          // Receitas e Despesas
                          Row(
                            children: [
                              Expanded(
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.green[200]!, width: 1),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Icon(Icons.arrow_downward, color: Colors.green, size: 28),
                                        SizedBox(height: 8),
                                        Text(
                                          'Receitas',
                                          style: TextStyle(color: Colors.green[700], fontSize: 12),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'R\$ ${transacaoVM.totalReceitas.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.red[200]!, width: 1),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Icon(Icons.arrow_upward, color: Colors.red, size: 28),
                                        SizedBox(height: 8),
                                        Text(
                                          'Despesas',
                                          style: TextStyle(color: Colors.red[700], fontSize: 12),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'R\$ ${transacaoVM.totalDespesas.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Abas de Filtro
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFiltroButton('todos', 'Todas'),
                            _buildFiltroButton('receita', '➕ Receitas'),
                            _buildFiltroButton('despesa', '➖ Despesas'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    // Lista de Transações
                    Expanded(
                      child: transacaoVM.transacoes.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
                                  SizedBox(height: 16),
                                  Text(
                                    'Nenhuma transação',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _getTransacoesFiltradas(transacaoVM).length,
                              itemBuilder: (context, index) {
                                final t = _getTransacoesFiltradas(transacaoVM)[index];
                                return Card(
                                  elevation: 1,
                                  margin: EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    leading: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: t.tipo == 'receita' ? Colors.green[100] : Colors.red[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(t.icone, style: TextStyle(fontSize: 24)),
                                      ),
                                    ),
                                    title: Text(
                                      t.titulo,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${t.categoria ?? 'Outro'} • ${t.dataFormatada}',
                                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${t.tipo == 'receita' ? '+' : '-'} R\$ ${t.valor.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: t.tipo == 'receita' ? Colors.green[700] : Colors.red[700],
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        SizedBox(
                                          width: 60,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () => _editarTransacao(t),
                                                child: Icon(Icons.edit, size: 18, color: Colors.blue[700]),
                                              ),
                                              SizedBox(width: 8),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text('Confirmar exclusão'),
                                                      content: Text('Deseja realmente excluir esta transação?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: Text('Cancelar'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            transacaoVM.removerTransacao(t.id!, usuarioId: t.usuarioId);
                                                            Navigator.pop(context);
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: Text('Transação removida!'),
                                                                backgroundColor: Colors.red,
                                                              ),
                                                            );
                                                          },
                                                          child: Text('Excluir', style: TextStyle(color: Colors.red)),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: Icon(Icons.delete, size: 18, color: Colors.red),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirModalAdicionarTransacao(context),
        backgroundColor: Colors.blue[700],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFiltroButton(String valor, String label) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _filtroSelecionado == valor,
        onSelected: (selected) => setState(() => _filtroSelecionado = valor),
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue[700],
        labelStyle: TextStyle(
          color: _filtroSelecionado == valor ? Colors.white : Colors.black,
          fontWeight: _filtroSelecionado == valor ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  List<Transacao> _getTransacoesFiltradas(TransacaoViewModel vm) {
    if (_filtroSelecionado == 'todos') {
      return vm.transacoes;
    } else if (_filtroSelecionado == 'receita') {
      return vm.filtrarPorTipo('receita');
    } else {
      return vm.filtrarPorTipo('despesa');
    }
  }
}
