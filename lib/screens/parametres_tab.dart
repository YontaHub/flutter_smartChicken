import 'package:flutter/material.dart';
import '../models/user.dart'; // Pour currentUser
import 'login_screen.dart'; // Pour déconnexion


  Utilisateur? currentUser;
class ParametresTab extends StatelessWidget {
  const ParametresTab({super.key});
 
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paramètres',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Card(
            elevation: 2.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profil Utilisateur', style: TextStyle(fontSize: 18.0)),
                  SizedBox(height: 8.0),
                  Text('Nom: ${currentUser?.nom ?? 'Non disponible'}'),
                  Text('Email: ${currentUser?.email ?? 'Non disponible'}'),
                  Text('Rôle: ${currentUser?.role ?? 'Non disponible'}'),
                  Text('Téléphone: ${currentUser?.telephone ?? 'Non disponible'}'),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                currentUser = null;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text('Déconnexion', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}