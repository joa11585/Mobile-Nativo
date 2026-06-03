import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transacao.dart';
import '../viewmodels/transacao_viewmodel.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransacaoViewModel>(context, listen: false).carregarTransacoes();
  }

  void _abrirModalAdicionarTransacao(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String titulo = '';
    double valor = 0.0;
    String tipo = 'despesa';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Título'),
                  validator: (value) => value!.isEmpty ? 'Obrigatório' : null,
                  onSaved: (value) => titulo = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty || double.tryParse(value) == null ? 'Valor inválido' : null,
                  onSaved: (value) => valor = double.parse(value!),
                ),
                DropdownButtonFormField<String>(
                  value: tipo,
                  items: ['receita', 'despesa'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) => tipo = val!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final novaTransacao = Transacao(titulo: titulo, valor: valor, data: DateTime.now().toString(), tipo: tipo);
                      Provider.of<TransacaoViewModel>(context, listen: false).adicionarTransacao(novaTransacao);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Adicionar'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transacaoViewModel = Provider.of<TransacaoViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard Financeiro')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Saldo Atual: R\$ ${transacaoViewModel.saldoTotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transacaoViewModel.transacoes.length,
              itemBuilder: (context, index) {
                final t = transacaoViewModel.transacoes[index];
                return ListTile(
                  title: Text(t.titulo),
                  subtitle: Text('R\$ ${t.valor.toStringAsFixed(2)} - ${t.tipo}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => transacaoViewModel.removerTransacao(t.id!),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirModalAdicionarTransacao(context),
        child: Icon(Icons.add),
      ),
    );
  }
}