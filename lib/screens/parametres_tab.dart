import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ajouté pour effacer les prefs
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('utilisateurs').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            currentUser = Utilisateur(
              nom: data['nom'] ?? 'Utilisateur Par Défaut',
              email: data['email'] ?? user.email ?? 'email@example.com',
              role: data['role'] ?? 'Utilisateur',
              telephone: data['telephone'] ?? '000-000-0000',
            );
            _nomController.text = currentUser!.nom;
            _emailController.text = currentUser!.email;
            _telephoneController.text = currentUser!.telephone;
          });
        } else {
          await _firestore.collection('utilisateurs').doc(user.uid).set({
            'nom': 'Utilisateur Par Défaut',
            'email': user.email ?? 'email@example.com',
            'role': 'Utilisateur',
            'telephone': '000-000-0000',
          });
          setState(() {
            currentUser = Utilisateur(
              nom: 'Utilisateur Par Défaut',
              email: user.email ?? 'email@example.com',
              role: 'Utilisateur',
              telephone: '000-000-0000',
            );
            _nomController.text = currentUser!.nom;
            _emailController.text = currentUser!.email;
            _telephoneController.text = currentUser!.telephone;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors du chargement des données: $e')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucun utilisateur connecté. Veuillez vous connecter.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  Future<void> _toggleEdit() async {
    if (_isEditing) {
      final user = _auth.currentUser;
      if (user != null) {
        try {
          await _firestore.collection('utilisateurs').doc(user.uid).update({
            'nom': _nomController.text,
            'email': _emailController.text,
            'telephone': _telephoneController.text,
          });
          setState(() {
            currentUser = currentUser?.copyWith(
              nom: _nomController.text,
              email: _emailController.text,
              telephone: _telephoneController.text,
            );
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profil mis à jour avec succès')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur lors de la mise à jour: $e')),
            );
          }
        }
      }
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.remove('rememberMe');
      setState(() {
        currentUser = null;
        _nomController.clear();
        _emailController.clear();
        _telephoneController.clear();
      });
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la déconnexion: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[700],
                  ),
                  child: Text('Paramètres'),
                ),
                SizedBox(height: 24.0),
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
                            if (currentUser != null)
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
                SizedBox(height: 120.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: currentUser != null ? _logout : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      disabledBackgroundColor: Colors.grey[400],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.blue[300]),
                        SizedBox(width: 20.0),
                        Text(
                          'Déconnexion',
                          style: TextStyle(fontSize: 16.0, color: Colors.blue[300], fontWeight: FontWeight.bold),
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
                  enabled: currentUser != null,
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