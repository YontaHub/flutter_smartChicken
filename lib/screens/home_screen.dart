import 'package:flutter/material.dart';
import 'accueil_tab.dart';
import 'vagues_tab.dart';
import 'traitements_tab.dart';
import 'vaccins_tab.dart';
import 'parametres_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Index de la tab sélectionnée (démarre sur Accueil)

  // Liste des widgets pour chaque tab
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}