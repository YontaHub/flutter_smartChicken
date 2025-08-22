import 'package:flutter/material.dart';
import '../models/data_manager.dart';

class VaccinsTab extends StatefulWidget {
  const VaccinsTab({super.key});

  @override
  VaccinsTabState createState() => VaccinsTabState();
}

class VaccinsTabState extends State<VaccinsTab> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final vaccins = DataManager().vaccins;
    return Padding(
      key: _key,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Planification des Vaccins',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: vaccins.length,
              itemBuilder: (context, index) {
                final vaccin = vaccins[index];
                final vagueName = DataManager().getVagueName(vaccin.vagueId);
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    leading: Icon(Icons.vaccines, color: Colors.green),
                    title: Text(vaccin.nom),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date Vaccination: ${vaccin.dateVaccination.toString().split(' ')[0]}'),
                        Text('Initié le: ${vaccin.dateInitiation.toString().split(' ')[0]}'),
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