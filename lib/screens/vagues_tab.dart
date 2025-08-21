import 'package:flutter/material.dart';
import '../screens/create_vague_screen.dart';
import '../widgets/card_widget.dart';
import '../models/vague.dart'; // Ajout d'un modèle pour les vagues

class VaguesTab extends StatefulWidget {
  const VaguesTab({super.key});

  @override
  VaguesTabState createState() => VaguesTabState();
}

class VaguesTabState extends State<VaguesTab> {
  final List<Vague> _vagues = []; // Liste pour stocker les vagues créées

  void _addVague(Vague vague) {
    setState(() {
      _vagues.add(vague); // Ajoute la nouvelle vague à la liste
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte interactive pour ajouter une vague
            Text(
              'Ajouter une vague',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            buildActionCard(
              icon: Icons.add,
              title: 'Créer une vague',
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateVagueScreen()),
                );
                if (result != null && result is Vague) {
                  _addVague(result); // Ajoute la vague créée
                }
              },
              color: Colors.green,
            ),
            SizedBox(height: 24.0),
            // Liste des vagues créées
            Text(
              'Vagues existantes',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _vagues.length,
              itemBuilder: (context, index) {
                final vague = _vagues[index];
                return Card(
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vague.nom,
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text('Date: ${vague.dateEnregistrement.toString().split(' ')[0]}'),
                          Text('Total: ${vague.nombreVivant - vague.nombreMort}'),
                          Text('Nombre Initial: ${vague.nombreVivant}'),
                          Text('Perte: ${vague.nombreMort}'),
                          Text('Jours: ${vague.nombreJours}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}