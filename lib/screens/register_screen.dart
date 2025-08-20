import 'package:flutter/material.dart';
import 'login_screen.dart'; // Pour retour au login

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String nom = '';
  String email = '';
  String role = 'fermier'; // Par défaut
  String telephone = '';
  String password = '';
  bool _isPasswordVisible = false; // Pour toggle visibilité

  void _register() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Logique de création (à remplacer par Firebase)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscription réussie pour $nom')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      'Inscription',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Créez votre compte pour commencer',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nom',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Entrez un nom';
                        return null;
                      },
                      onSaved: (value) => nom = value ?? '',
                    ),
                    SizedBox(height: 16.0),
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
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Rôle',
                        prefixIcon: Icon(Icons.work_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      value: role,
                      items: ['fermier', 'admin'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => role = value ?? 'fermier');
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Téléphone',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Entrez un téléphone';
                        if (value.length < 9) return 'Numéro invalide';
                        return null;
                      },
                      onSaved: (value) => telephone = value ?? '',
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
                    SizedBox(height: 24.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: Text('S\'inscrire', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text('Déjà un compte ? Se connecter'),
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