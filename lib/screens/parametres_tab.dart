import 'package:flutter/material.dart';// Pour currentUser
import 'login_screen.dart'; // Pour déconnexion

class ParametresTab extends StatefulWidget {
  const ParametresTab({super.key});

  @override
  ParametresTabState createState() => ParametresTabState();
}

class ParametresTabState extends State<ParametresTab> {
  Utilisateur? currentUser; // État pour l'utilisateur courant
  bool _isEditing = false; // État pour activer/désactiver l'édition
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les données actuelles de l'utilisateur
    currentUser = currentUser ?? Utilisateur(nom: 'Utilisateur Par Défaut', email: 'email@example.com', role: 'Utilisateur', telephone: '000-000-0000');
    _nomController.text = currentUser?.nom ?? '';
    _emailController.text = currentUser?.email ?? '';
    _telephoneController.text = currentUser?.telephone ?? '';
  }

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
    if (!_isEditing) {
      // Sauvegarder les modifications si nécessaire
      setState(() {
        currentUser = currentUser?.copyWith(
          nom: _nomController.text,
          email: _emailController.text,
          telephone: _telephoneController.text,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600), // Limite la largeur pour les grands écrans
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre avec animation
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text('Paramètres'),
                ),
                SizedBox(height: 24.0),
                // Card pour le profil
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Profil Utilisateur',
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.blueGrey[700]),
                            ),
                            IconButton(
                              icon: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.blue),
                              onPressed: _toggleEdit,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        _buildProfileField('Nom', _nomController, _isEditing),
                        SizedBox(height: 12.0),
                        _buildProfileField('Email', _emailController, _isEditing),
                        SizedBox(height: 12.0),
                        _buildProfileField('Téléphone', _telephoneController, _isEditing),
                        SizedBox(height: 12.0),
                        Text(
                          'Rôle: ${currentUser?.role ?? 'Non disponible'}',
                          style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                // Bouton de déconnexion avec animation
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentUser = null;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.white),
                        SizedBox(width: 8.0),
                        Text(
                          'Déconnexion',
                          style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, bool isEditable) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          label == 'Nom' ? Icons.person : label == 'Email' ? Icons.email : Icons.phone,
          size: 20.0,
          color: Colors.grey[600],
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: isEditable
              ? TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: label,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  style: TextStyle(fontSize: 16.0),
                )
              : Text(
                  '$label: ${controller.text}',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[800]),
                ),
        ),
      ],
    );
  }
}

// Exemple de modèle User (si non défini ailleurs)
class Utilisateur {
  final String nom;
  final String email;
  final String role;
  final String telephone;

  Utilisateur({
    required this.nom,
    required this.email,
    required this.role,
    required this.telephone,
  });

  Utilisateur copyWith({
    String? nom,
    String? email,
    String? role,
    String? telephone,
  }) {
    return Utilisateur(
      nom: nom ?? this.nom,
      email: email ?? this.email,
      role: role ?? this.role,
      telephone: telephone ?? this.telephone,
    );
  }
}