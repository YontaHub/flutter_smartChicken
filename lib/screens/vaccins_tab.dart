import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/vaccin.dart';

class VaccinsTab extends StatefulWidget {
  const VaccinsTab({super.key});

  @override
  VaccinsTabState createState() => VaccinsTabState();
}

class VaccinsTabState extends State<VaccinsTab> {
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
            'Planification des Vaccins',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('vaccins')
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
                  return Center(child: Text('Aucun vaccin trouvé'));
                }
                final vaccins = snapshot.data!.docs.map((doc) {
                  return Vaccin.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                }).toList();
                return ListView.builder(
                  itemCount: vaccins.length,
                  itemBuilder: (context, index) {
                    final vaccin = vaccins[index];
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
                            Text('Vague: ${vaccin.nom}'), // À remplacer par le nom de la vague si disponible
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