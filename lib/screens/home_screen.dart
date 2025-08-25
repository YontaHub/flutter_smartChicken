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
  int _selectedIndex = 0;

  // Fonction pour re-rendre les onglets
  // void _refreshTabs() {
  //   setState(() {
  //     print("Tabs refreshed, current index: $_selectedIndex"); // Débogage
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          AccueilTab(),
          VaguesTab(),
          TraitementsTab(),
          VaccinsTab(),
          ParametresTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Vagues'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Traitements'),
          BottomNavigationBarItem(icon: Icon(Icons.vaccines), label: 'Vaccins'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}