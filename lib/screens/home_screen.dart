import 'package:flutter/material.dart';
import '../models/user.dart'; // Pour currentUser
import 'login_screen.dart'; // Pour déconnexion

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Index de la tab sélectionnée (démarre sur Accueil)

  // Liste des widgets pour chaque tab (utilise IndexedStack pour préserver l'état)
  static const List<Widget> _widgetOptions = <Widget>[
    AccueilTab(), // Tab Accueil
    VaguesTab(), // Tab Vagues
    TraitementsTab(), // Tab Traitements
    VaccinsTab(), // Tab Vaccins
    ParametresTab(), // Tab Paramètres
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Change la tab sélectionnée
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions, // Affiche la tab sélectionnée
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icône maison pour Accueil
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group), // Icône groupe pour Vagues (lots)
            label: 'Vagues',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services), // Icône médicale pour Traitements
            label: 'Traitements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vaccines), // Icône seringue pour Vaccins
            label: 'Vaccins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Icône engrenage pour Paramètres
            label: 'Paramètres',
          ),
        ],
        currentIndex: _selectedIndex, // Tab active
        selectedItemColor: Colors.green[700], // Couleur sélectionnée (vert comme boutons)
        unselectedItemColor: Colors.grey, // Gris pour non sélectionné, comme dans l'image
        onTap: _onItemTapped, // Gère le tap sur une tab
        type: BottomNavigationBarType.fixed, // Fixe pour afficher tous les labels
      ),
    );
  }
}

// Placeholder pour Tab Accueil
class AccueilTab extends StatelessWidget {
  const AccueilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page d\'Accueil - Bienvenue !'), // Contenu placeholder
    );
  }
}

// Placeholder pour Tab Vagues
class VaguesTab extends StatelessWidget {
  const VaguesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Gestion des Vagues'), // À développer : liste des lots
    );
  }
}

// Placeholder pour Tab Traitements
class TraitementsTab extends StatelessWidget {
  const TraitementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Planification des Traitements'), // À développer : calendrier traitements
    );
  }
}

// Placeholder pour Tab Vaccins
class VaccinsTab extends StatelessWidget {
  const VaccinsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Planification des Vaccins'), // À développer : calendrier vaccins
    );
  }
}

Utilisateur? currentUser;
// Tab Paramètres avec Profil et Déconnexion
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
          // Section Profil (affiche infos user)
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
          // Bouton Déconnexion
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Simule déconnexion : reset currentUser et retour à login
                currentUser = null;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Rouge pour déconnexion
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