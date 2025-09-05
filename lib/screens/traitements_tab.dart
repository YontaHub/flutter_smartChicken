import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/traitement.dart';

class TraitementsTab extends StatefulWidget {
  const TraitementsTab({super.key});

  @override
  TraitementsTabState createState() => TraitementsTabState();
}

class TraitementsTabState extends State<TraitementsTab> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('traitements')
                  .where('userId', isEqualTo: user?.uid ?? '')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Aucun traitement trouvé'));
                }
                final traitements = snapshot.data!.docs.map((doc) {
                  return Traitement.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                }).toList();
                return ListView.builder(
                  itemCount: traitements.length,
                  itemBuilder: (context, index) {
                    final traitement = traitements[index];
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
                            Text('Vague: ${traitement.nom}'), // À remplacer par le nom de la vague si disponible
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}