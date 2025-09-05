import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_chick/models/traitement.dart';
import 'package:smart_chick/models/vaccin.dart';
import '../screens/create_vague_screen.dart';
import '../widgets/card_widget.dart';
import '../models/vague.dart';
import 'plan_vaccin_screen.dart';
import 'plan_traitement_screen.dart';

class VaguesTab extends StatefulWidget {
  final Function()? onDataUpdated;

  const VaguesTab({super.key, this.onDataUpdated});

  @override
  VaguesTabState createState() => VaguesTabState();
}

class VaguesTabState extends State<VaguesTab> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Section fixe pour ajouter une vague, toujours affichée si l'utilisateur est connecté
    Widget addVagueSection = user != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ajouter une vague',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              buildActionCard(
                icon: Icons.add,
                title: 'Créer une vague',
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateVagueScreen()),
                  );
                },
                color: Colors.green,
              ),
              SizedBox(height: 24.0),
            ],
          )
        : Center(child: Text('Veuillez vous connecter pour voir vos vagues'));

    return Padding(
      key: _key,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVagueSection,
            Text(
              'Vagues existantes',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('vagues')
                  .where('userId', isEqualTo: user?.uid ?? '') // Filtrer par utilisateur
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Aucune vague trouvée pour cet utilisateur'));
                }

                final vagues = snapshot.data!.docs.map((doc) {
                  try {
                    return Vague.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                  } catch (e) {
                    return Vague(
                      nom: 'Erreur: Données invalides pour ${doc.id}',
                      dateEnregistrement: DateTime.now(),
                      nombreVivant: 0,
                      nombreMort: 0,
                      nombreJours: 0,
                      userId: user?.uid ?? '',
                    );
                  }
                }).toList();


                Future<void> deleteVague(String docId) async {
                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmer la suppression'),
                        content: Text('Êtes-vous sûr de vouloir supprimer cette vague ? Cette action est irréversible.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Annuler', style: TextStyle(color: Colors.grey)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    await FirebaseFirestore.instance.collection('vagues').doc(docId).delete();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Vague supprimée avec succès')),
                    );
                    if (widget.onDataUpdated != null) {
                      widget.onDataUpdated!();
                    }
                  }
                }

                void registerDeath(String docId, int currentVivant) {
                  if (currentVivant > 0) {
                    FirebaseFirestore.instance.collection('vagues').doc(docId).update({
                      'nombreMort': FieldValue.increment(1),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Un sujet est marqué comme décédé')),
                    );
                  }
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: vagues.length,
                  itemBuilder: (context, index) {
                    final vague = vagues[index];
                    int nombreTotal = vague.nombreVivant - vague.nombreMort;
                    double progressionJours = vague.nombreJours / 45.0;

                    if (vague.vagueId == null) {
                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Erreur : ID manquant pour ${vague.nom}'),
                        ),
                      );
                    }

                    return Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      margin: EdgeInsets.only(bottom: 16.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  vague.nom,
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                                  onSelected: (String value) {
                                    final validVagueId = vague.vagueId!;
                                    if (value == 'vaccination') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlanVaccinScreen(vagueId: int.tryParse(validVagueId) ?? 0),
                                        ),
                                      ).then((result) {
                                        if (result != null && result is Vaccin) {
                                          // Gérer l'ajout de vaccin
                                        }
                                      });
                                    } else if (value == 'traitement') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlanTraitementScreen(vagueId: int.tryParse(validVagueId) ?? 0),
                                        ),
                                      ).then((result) {
                                        if (result != null && result is Traitement) {
                                          // Gérer l'ajout de traitement
                                        }
                                      });
                                    } else if (value == 'delete') {
                                      deleteVague(validVagueId);
                                    } else if (value == 'death') {
                                      registerDeath(validVagueId, vague.nombreVivant);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'vaccination',
                                      child: ListTile(
                                        leading: Icon(Icons.vaccines, color: Colors.green),
                                        title: Text('Planifier une vaccination'),
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'traitement',
                                      child: ListTile(
                                        leading: Icon(Icons.medical_services, color: Colors.blue),
                                        title: Text('Planifier un traitement'),
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'death',
                                      child: ListTile(
                                        leading: Icon(Icons.remove_circle, color: Colors.red),
                                        title: Text('Signaler un décès'),
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: ListTile(
                                        leading: Icon(Icons.delete, color: Colors.red),
                                        title: Text('Supprimer une vague'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.group, color: Colors.green, size: 20.0),
                                      SizedBox(width: 8.0),
                                      Text('Total: $nombreTotal', style: TextStyle(color: Colors.green[800])),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.person, color: Colors.blue, size: 20.0),
                                      SizedBox(width: 8.0),
                                      Text('Initial: ${vague.nombreVivant}', style: TextStyle(color: Colors.blue[800])),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.remove_circle, color: Colors.red, size: 20.0),
                                      SizedBox(width: 8.0),
                                      Text('Perte: ${vague.nombreMort}', style: TextStyle(color: Colors.red[800])),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today, color: Colors.orange, size: 20.0),
                                      SizedBox(width: 8.0),
                                      Text('Jours: ${vague.nombreJours}', style: TextStyle(color: Colors.orange[800])),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Icon(Icons.date_range, color: Colors.purple, size: 20.0),
                                SizedBox(width: 8.0),
                                Text(
                                  'Arrivée: ${vague.dateArrivee.toString().split(' ')[0]}',
                                  style: TextStyle(color: Colors.purple[800]),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            LinearProgressIndicator(
                              value: progressionJours.clamp(0.0, 1.0),
                              backgroundColor: Colors.grey[300],
                              color: Colors.green,
                              minHeight: 8.0,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
   void addVague(Vague vague) async {
                  try {
                    await FirebaseFirestore.instance.collection('vagues').add(vague.toMap());
                    if (widget.onDataUpdated != null) {
                      widget.onDataUpdated!();
                    }
                    setState(() {}); // Forcer une mise à jour
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur lors de l\'ajout : $e')),
                    );
                  }
                }
}