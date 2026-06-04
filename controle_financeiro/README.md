# 📊 Controle Financeiro - Aplicativo Flutter

Um aplicativo completo de controle financeiro desenvolvido em Flutter, seguindo a arquitetura MVVM com persistência local em SQLite e gerenciamento de estado com Provider.

---

## ✨ Funcionalidades

### ✅ Nível Básico (Funcional Local)
- **Autenticação de Usuários**: Login e cadastro com validação
- **Gestão de Transações**: Adicionar, editar e remover transações
- **Cálculo Automático de Saldo**: Atualização em tempo real
- **Categorização**: Organize transações por categorias
- **Persistência**: SQLite com dados preservados ao fechar o app
- **Gerenciamento de Estado**: Provider para reatividade entre telas
- **Validação de Formulários**: Campos obrigatórios e formatos validados

### 🎯 Nível Avançado (Premium)
- **Dashboard Rico em Dados**: Cartões com resumo de saldo, receitas e despesas
- **Filtros Dinâmicos**: Visualize todas, apenas receitas ou apenas despesas
- **Edição de Transações**: Atualize informações após criação
- **UX/UI Superior**: Design moderno com Material Design 3
- **Feedback Visual**: Loading states, SnackBars e animações
- **Relatórios Básicos**: Totais por tipo e categoria

---

## 🏗️ Arquitetura MVVM

```
lib/
├── models/              # Modelos de dados (Usuario, Transacao)
├── viewmodels/          # Lógica de negócio (AuthViewModel, TransacaoViewModel)
├── views/               # Interface do usuário (Login, Cadastro, Dashboard)
├── database/            # Camada de persistência (DatabaseHelper)
├── utils/               # Constantes e utilitários
└── main.dart            # Entrada da aplicação
```

---

## 📱 Estrutura do Banco de Dados

### Tabela: usuarios
```sql
CREATE TABLE usuarios (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  senha TEXT NOT NULL
)
```

### Tabela: transacoes
```sql
CREATE TABLE transacoes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  usuario_id INTEGER NOT NULL,
  titulo TEXT NOT NULL,
  valor REAL NOT NULL,
  data TEXT NOT NULL,
  tipo TEXT NOT NULL,
  categoria TEXT,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
)
```

---

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK 3.12+
- Dart 3.12+
- Um editor (VS Code, Android Studio ou similar)

### Passos

1. **Navegue para a pasta do projeto**
```bash
cd controle_financeiro
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute no emulador ou dispositivo**
```bash
flutter run
```

4. **Para executar no Web (Codespaces)**
```bash
flutter run -d web
```

---

## 📦 Dependências

```yaml
provider: ^6.1.5+1      # Gerenciamento de estado
sqflite: ^2.4.3         # Banco de dados local
path_provider: ^2.1.5   # Acesso ao sistema de arquivos
```

---

## 👤 Fluxo de Usuário

### 1. **Tela de Login**
- E-mail e senha obrigatórios
- Validação de formato de e-mail
- Botão para navegar ao cadastro

### 2. **Tela de Cadastro**
- Nome, e-mail e senha obrigatórios
- Validação de senha duplicada
- Prevenção de e-mails duplicados

### 3. **Dashboard**
- **Cartões de Resumo**: Saldo total, receitas e despesas
- **Filtros**: Todas, receitas ou despesas
- **Lista de Transações**: 
  - Título, valor, categoria e data
  - Ícones visuais por categoria
  - Botões para editar e deletar
  - Cores diferenciadas (verde=receita, vermelho=despesa)
- **FAB**: Botão flutuante para adicionar nova transação
- **Logout**: Botão no AppBar para desconectar

---

## 🎨 Design e UX

- **Tema**: Material Design 3 com cores azuis
- **Componentes**: Cards, TextFields validados, BottomSheets
- **Feedback**: SnackBars para confirmação de ações
- **Loading States**: Indicadores de progresso em operações assíncronas
- **Estados Vazios**: Mensagem quando não há transações

---

## 🔐 Segurança

⚠️ **Nota**: Este é um aplicativo educacional. Em produção:
- Use hash de senha (bcrypt, argon2)
- Implemente autenticação robusta (JWT, OAuth)
- Use HTTPS para comunicação
- Nunca armazene dados sensíveis em texto plano

---

## 🐛 Troubleshooting

### Erro: "DatabaseException - database is locked"
- Limpe o build: `flutter clean`
- Exclua o banco de dados anterior

### Erro: "E-mail já cadastrado" em novo cadastro
- O e-mail já existe no banco
- Use um e-mail diferente

### Transações não aparecem após logout/login
- As transações estão salvas por usuário
- Faça login com a conta que criou as transações

---

## 📋 Checklist de Funcionalidades

- ✅ Autenticação (Login/Cadastro)
- ✅ CRUD de Transações (Adicionar, Ler, Atualizar, Deletar)
- ✅ Cálculo de Saldo Automático
- ✅ Persistência em SQLite
- ✅ Gerenciamento de Estado com Provider
- ✅ Validação de Formulários
- ✅ Categorização de Transações
- ✅ Filtros Dinâmicos
- ✅ Dashboard com Resumo
- ✅ UX/UI Moderna
- ✅ Feedback Visual
- ✅ Relacionamento Usuário-Transações

---

## 🚧 Melhorias Futuras

- [ ] Integração com Firebase (Firestore + Auth)
- [ ] Sincronização em nuvem
- [ ] Gráficos e estatísticas avançadas
- [ ] Importação/Exportação de dados
- [ ] Notificações de lembretes
- [ ] Tema claro/escuro
- [ ] Suporte a múltiplas moedas
- [ ] Biometria (fingerprint/face)

---

## 📄 Licença

Este projeto é educacional e pode ser usado livremente para fins de aprendizado.

---

## 👨‍💻 Desenvolvedor

Desenvolvido como projeto acadêmico de Mobile Development com Flutter e MVVM.

---

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique o console do Flutter (`flutter run -v`)
2. Consulte a documentação oficial do Flutter
3. Verifique a estrutura do banco de dados
