class AppConstants {
  // Categorias de Despesas
  static const List<String> categoriasDesp = [
    'Alimentação',
    'Transporte',
    'Saúde',
    'Educação',
    'Lazer',
    'Moradia',
    'Utilidades',
    'Outros',
  ];

  // Categorias de Receitas
  static const List<String> categoriasRec = [
    'Salário',
    'Investimento',
    'Freelance',
    'Bônus',
    'Devolução',
    'Outros',
  ];

  // Mapa de Ícones por Categoria
  static const Map<String, String> categoriasIcones = {
    'Alimentação': '🍔',
    'Transporte': '🚗',
    'Saúde': '🏥',
    'Educação': '📚',
    'Lazer': '🎬',
    'Moradia': '🏠',
    'Utilidades': '💡',
    'Salário': '💰',
    'Investimento': '📈',
    'Freelance': '💻',
    'Bônus': '🎁',
    'Devolução': '↩️',
    'Outros': '📌',
  };

  // Cores por Tipo
  static const Map<String, int> coresPorTipo = {
    'receita': 0xFF4CAF50, // Verde
    'despesa': 0xFFF44336, // Vermelho
  };
}
