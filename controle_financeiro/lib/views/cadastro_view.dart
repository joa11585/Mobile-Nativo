import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario.dart';
import '../viewmodels/auth_viewmodel.dart';

class CadastroView extends StatefulWidget {
  @override
  _CadastroViewState createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmSenhaController = TextEditingController();
  bool _senhaVisivel = false;
  bool _confirmSenhaVisivel = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmSenhaController.dispose();
    super.dispose();
  }

  void _fazerCadastro() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      if (_senhaController.text != _confirmSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('As senhas não coincidem'), backgroundColor: Colors.red),
        );
        return;
      }

      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      Usuario novoUser = Usuario(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
      );
      
      bool sucesso = await authViewModel.cadastrar(novoUser);
      
      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cadastrado com sucesso! Faça login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authViewModel.errorMessage ?? 'Erro ao cadastrar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
        elevation: 0,
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Text(
                  'Criar Conta',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome Completo',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Nome obrigatório' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'E-mail obrigatório';
                    if (!value.contains('@')) return 'E-mail inválido';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_senhaVisivel ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  obscureText: !_senhaVisivel,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Senha obrigatória';
                    if (value.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmSenhaController,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_confirmSenhaVisivel ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _confirmSenhaVisivel = !_confirmSenhaVisivel),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  obscureText: !_confirmSenhaVisivel,
                  validator: (value) => value == null || value.isEmpty ? 'Confirme a senha' : null,
                ),
                SizedBox(height: 28),
                Consumer<AuthViewModel>(
                  builder: (context, authVM, _) {
                    return ElevatedButton(
                      onPressed: authVM.isLoading ? null : _fazerCadastro,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blue[700],
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: authVM.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Cadastrar',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
