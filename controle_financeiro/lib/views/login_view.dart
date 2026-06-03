import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'cadastro_view.dart';
import 'dashboard_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String senha = '';

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) => senha = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    bool sucesso = await authViewModel.login(email, senha);
                    if (sucesso) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardView()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('E-mail ou senha incorretos')));
                    }
                  }
                },
                child: Text('Entrar'),
              ),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CadastroView())),
                child: Text('Não tem conta? Cadastre-se'),
              )
            ],
          ),
        ),
      ),
    );
  }
}