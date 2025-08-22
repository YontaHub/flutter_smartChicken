import 'package:flutter/material.dart';
import '../models/data_manager.dart';

class TraitementsTab extends StatefulWidget {
  const TraitementsTab({super.key});

  @override
  TraitementsTabState createState() => TraitementsTabState();
}

class TraitementsTabState extends State<TraitementsTab> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final traitements = DataManager().traitements;
    return Padding(
      key: _key,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Planification des Traitements',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: traitements.length,
              itemBuilder: (context, index) {
                final traitement = traitements[index];
                final vagueName = DataManager().getVagueName(traitement.vagueId);
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    leading: Icon(Icons.medical_services, color: Colors.blue),
                    title: Text(traitement.nom),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Du: ${traitement.dateDebut.toString().split(' ')[0]} au ${traitement.dateFin.toString().split(' ')[0]}'),
                        Text('Initié le: ${traitement.dateInitiation.toString().split(' ')[0]}'),
                        Text('Vague: $vagueName'), // Affichage du nom de la vague
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}