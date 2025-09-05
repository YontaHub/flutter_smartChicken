import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_chick/models/vague.dart';
import '../screens/create_vague_screen.dart';
import '../widgets/card_widget.dart';
import 'chat_screen.dart';

class AccueilTab extends StatelessWidget {
  final Function()? onDataUpdated;

  const AccueilTab({super.key, this.onDataUpdated});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: user != null
          ? FirebaseFirestore.instance
              .collection('vagues')
              .where('userId', isEqualTo: user.uid)
              .snapshots()
          : const Stream.empty(), // Si pas d'utilisateur, ne rien afficher
      builder: (context, snapshot) {
        int vaguesActives = 0;
        int totalSujets = 0;
        if (snapshot.hasData) {
          final vagues = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Vague.fromMap(data, doc.id);
          }).toList();
          vaguesActives = vagues.length;
          // ignore: avoid_types_as_parameter_names
          totalSujets = vagues.fold(0, (sum, vague) => sum + vague.nombreVivant - vague.nombreMort);
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        final data = {
          'vaguesActives': {'count': vaguesActives},
          'totalSujets': {'count': totalSujets},
        };

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vue d\'ensemble',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = (constraints.maxWidth / 200).floor().clamp(1, 2);
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.0,
                      children: [
                        buildCard(
                          icon: Icons.group,
                          title: 'Vagues actives',
                          count: data['vaguesActives']!['count'].toString(),
                          color: Colors.green,
                        ),
                        buildCard(
                          icon: Icons.show_chart,
                          title: 'Total sujets',
                          count: data['totalSujets']!['count'].toString(),
                          color: Colors.green,
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 24.0),
                Text(
                  'Actions rapides',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = (constraints.maxWidth / 200).floor().clamp(1, 2);
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.0,
                      children: [
                        buildActionCard(
                          icon: Icons.add,
                          title: 'Créer une vague',
                          onTap: () async {
                            if (user != null) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CreateVagueScreen()),
                              );
                              if (result != null && result is Vague) {
                                await FirebaseFirestore.instance.collection('vagues').add({
                                  ...result.toMap(),
                                  'userId': user.uid, // Assure que userId est inclus
                                });
                                if (onDataUpdated != null) {
                                  onDataUpdated!();
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Veuillez vous connecter pour créer une vague.')),
                              );
                            }
                          },
                          color: Colors.green,
                        ),
                        buildActionCard(
                          icon: Icons.chat,
                          title: 'Parler à l\'IA',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChatScreen()),
                            );
                          },
                          color: Colors.green,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}