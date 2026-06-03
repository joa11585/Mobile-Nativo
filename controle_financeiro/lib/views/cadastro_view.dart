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
  String nome = '';
  String email = '';
  String senha = '';

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Obrigatório' : null,
                onSaved: (value) => nome = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: (value) => value!.isEmpty || !value.contains('@') ? 'E-mail inválido' : null,
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Obrigatório' : null,
                onSaved: (value) => senha = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Usuario novoUser = Usuario(nome: nome, email: email, senha: senha);
                    bool sucesso = await authViewModel.cadastrar(novoUser);
                    if (sucesso) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cadastrado com sucesso!')));
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('Cadastrar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}