import 'package:flutter/material.dart';
import '../models/user.dart'; // Import pour Utilisateur et currentUser
import 'register_screen.dart'; // Pour navigation vers register

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool rememberMe = false;
  bool _isPasswordVisible = false; // Pour toggle visibilité

  Utilisateur? currentUser;

  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Logique de validation manuelle (à remplacer par Firebase)
      if (email == 'test@example.com' && password == 'password123') {
        // Simule un user connecté (hardcoded pour l'instant)
        currentUser = Utilisateur(
          nom: 'Test User',
          email: email,
          role: 'fermier',
          telephone: '123456789',
        );
        // Redirige vers la page d'accueil (home) après succès
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email ou mot de passe incorrect')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Le build reste le même que précédemment, fidèle au design
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            elevation: 4.0,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connexion',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Connectez-vous à votre compte pour continuer',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 24.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Adresse email',
                        prefixIcon: Icon(Icons.mail_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Entrez un email';
                        if (!value.contains('@')) return 'Email invalide';
                        return null;
                      },
                      onSaved: (value) => email = value ?? '',
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() => _isPasswordVisible = !_isPasswordVisible);
                          },
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Entrez un mot de passe';
                        if (value.length < 6) return 'Minimum 6 caractères';
                        return null;
                      },
                      onSaved: (value) => password = value ?? '',
                    ),
                    SizedBox(height: 8.0),
                    CheckboxListTile(
                      title: Text('Se souvenir de moi'),
                      value: rememberMe,
                      onChanged: (bool? value) {
                        setState(() => rememberMe = value ?? false);
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: Text('Se connecter', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text('Pas encore de compte ? Créer un compte'),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Implémenter réinitialisation mot de passe
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Fonctionnalité à venir')),
                          );
                        },
                        child: Text('Mot de passe oublié ?'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}