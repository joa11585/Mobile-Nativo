import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodels/transacao_viewmodel.dart';
import '../models/transacao.dart';

class GraficosView extends StatefulWidget {
  @override
  State<GraficosView> createState() => _GraficosViewState();
}

class _GraficosViewState extends State<GraficosView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TransacaoViewModel>().carregarTransacoes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📊 Estatísticas e Gráficos'),
        elevation: 0,
      ),
      body: Consumer<TransacaoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.transacoes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhuma transação para exibir gráficos'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Voltar'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumo de Gastos
                _buildResumoCard(viewModel),
                SizedBox(height: 24),

                // Gráfico de Pizza - Distribuição por Categoria
                Text(
                  'Distribuição por Categoria',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildPieChart(viewModel),
                SizedBox(height: 24),

                // Gráfico de Barras - Receitas vs Despesas
                Text(
                  'Receitas vs Despesas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildBarChart(viewModel),
                SizedBox(height: 24),

                // Gráfico de Linha - Progresso ao longo do tempo
                Text(
                  'Progresso do Saldo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildLineChart(viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResumoCard(TransacaoViewModel viewModel) {
    final receitas = viewModel.transacoes
        .where((t) => t.tipo == 'Receita')
        .fold<double>(0, (sum, t) => sum + t.valor);
    final despesas = viewModel.transacoes
        .where((t) => t.tipo == 'Despesa')
        .fold<double>(0, (sum, t) => sum + t.valor);
    final saldo = receitas - despesas;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo Financeiro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildResumoItem('Receitas', receitas, Colors.green),
              _buildResumoItem('Despesas', despesas, Colors.red),
              _buildResumoItem('Saldo', saldo, Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumoItem(String label, double valor, Color cor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'R\$ ${valor.toStringAsFixed(2)}',
          style: TextStyle(
            color: cor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart(TransacaoViewModel viewModel) {
    final categoriaMap = <String, double>{};

    for (var transacao in viewModel.transacoes) {
      if (transacao.tipo == 'Despesa') {
        categoriaMap.update(
          transacao.categoria,
          (value) => value + transacao.valor,
          ifAbsent: () => transacao.valor,
        );
      }
    }

    if (categoriaMap.isEmpty) {
      return Center(
        child: Text('Nenhuma despesa para exibir'),
      );
    }

    final cores = [
      Colors.red[400]!,
      Colors.orange[400]!,
      Colors.yellow[400]!,
      Colors.green[400]!,
      Colors.blue[400]!,
      Colors.purple[400]!,
    ];

    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: PieChart(
        PieChartData(
          sections: List.generate(
            categoriaMap.entries.length,
            (index) {
              final entry = categoriaMap.entries.elementAt(index);
              return PieChartSectionData(
                color: cores[index % cores.length],
                value: entry.value,
                title: entry.key,
                radius: 100,
                titleStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
          centerSpaceRadius: 40,
          sectionsSpace: 0,
        ),
      ),
    );
  }

  Widget _buildBarChart(TransacaoViewModel viewModel) {
    final receitas = viewModel.transacoes
        .where((t) => t.tipo == 'Receita')
        .fold<double>(0, (sum, t) => sum + t.valor);
    final despesas = viewModel.transacoes
        .where((t) => t.tipo == 'Despesa')
        .fold<double>(0, (sum, t) => sum + t.valor);

    final maxY = [receitas, despesas].reduce((a, b) => a > b ? a : b);

    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: receitas,
                  color: Colors.green[400],
                  width: 40,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: despesas,
                  color: Colors.red[400],
                  width: 40,
                ),
              ],
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return Text('Receitas');
                  if (value == 1) return Text('Despesas');
                  return Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('R\$ ${value.toInt()}');
                },
              ),
            ),
          ),
          maxY: maxY * 1.1,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }

  Widget _buildLineChart(TransacaoViewModel viewModel) {
    // Agrupar transações por data e calcular saldo acumulado
    final transacoesPorData = <String, double>{};
    double saldoAcumulado = 0;

    final transacoesOrdenadas = List<Transacao>.from(viewModel.transacoes)
      ..sort((a, b) => a.data.compareTo(b.data));

    for (var transacao in transacoesOrdenadas) {
      if (transacao.tipo == 'Receita') {
        saldoAcumulado += transacao.valor;
      } else {
        saldoAcumulado -= transacao.valor;
      }
      transacoesPorData[transacao.data] = saldoAcumulado;
    }

    if (transacoesPorData.isEmpty) {
      return Center(child: Text('Sem dados'));
    }

    final spots = List.generate(
      transacoesPorData.length,
      (index) => FlSpot(
        index.toDouble(),
        transacoesPorData.values.elementAt(index),
      ),
    );

    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: LineChart(
        LineChartData(
          spots: spots,
          isCurved: true,
          colors: [Colors.blue[400]!],
          barData: BarAreaData(
            show: true,
            colors: [Colors.blue[100]!],
          ),
          dotData: FlDotData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('R\$ ${value.toInt()}');
                },
              ),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}
