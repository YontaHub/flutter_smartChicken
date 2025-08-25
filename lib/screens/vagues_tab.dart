import 'package:flutter/material.dart';
import 'package:smart_chick/models/traitement.dart';
import 'package:smart_chick/models/vaccin.dart';
import '../screens/create_vague_screen.dart';
import '../widgets/card_widget.dart';
import '../models/vague.dart';
import 'plan_vaccin_screen.dart';
import 'plan_traitement_screen.dart';
import '../models/data_manager.dart';

class VaguesTab extends StatefulWidget {
  final Function()? onDataUpdated;

  const VaguesTab({super.key, this.onDataUpdated});

  @override
  VaguesTabState createState() => VaguesTabState();
}

class VaguesTabState extends State<VaguesTab> {
  final GlobalKey _key = GlobalKey(); // Clé pour forcer le re-rendu

  @override
  Widget build(BuildContext context) {
    // Recharger _vagues à partir de DataManager à chaque build
    final List<Vague> vagues = List.from(DataManager().vagues);

    void addVague(Vague vague) {
      setState(() {
        DataManager().addVague(vague);
      });
      if (widget.onDataUpdated != null) {
        widget.onDataUpdated!();
      }
    }

    Future<void> deleteVague(int index) async {
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
        setState(() {
          final vagueToRemove = vagues[index];
          DataManager().vagues.removeWhere((v) => v.vagueId == vagueToRemove.vagueId);
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vague supprimée avec succès')),
        );
        if (widget.onDataUpdated != null) {
          widget.onDataUpdated!();
        }
      }
    }

    void registerDeath(int index) {
      setState(() {
        if (vagues[index].nombreVivant > 0) {
          vagues[index].nombreMort += 1;
          DataManager().vagues[index] = vagues[index]; // Mettre à jour DataManager
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Un sujet est marqué comme décédé')),
      );
    }

    return Padding(
      key: _key, // Utiliser la clé pour forcer le re-rendu
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
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
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateVagueScreen()),
                );
                if (result != null && result is Vague) {
                  addVague(result);
                }
              },
              color: Colors.green,
            ),
            SizedBox(height: 24.0),
            Text(
              'Vagues existantes',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: vagues.length,
              itemBuilder: (context, index) {
                final vague = vagues[index];
                int nombreTotal = vague.nombreVivant - vague.nombreMort;
                double progressionJours = vague.nombreJours / 45.0;

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
                                if (value == 'vaccination') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlanVaccinScreen(vagueId: vague.vagueId),
                                    ),
                                  ).then((result) {
                                    if (result != null && result is Vaccin) {
                                      DataManager().addVaccin(result);
                                      if (widget.onDataUpdated != null) {
                                        widget.onDataUpdated!();
                                      }
                                    }
                                  });
                                } else if (value == 'traitement') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlanTraitementScreen(vagueId: vague.vagueId),
                                    ),
                                  ).then((result) {
                                    if (result != null && result is Traitement) {
                                      DataManager().addTraitement(result);
                                      if (widget.onDataUpdated != null) {
                                        widget.onDataUpdated!();
                                      }
                                    }
                                  });
                                } else if (value == 'delete') {
                                  deleteVague(index);
                                } else if (value == 'death') {
                                  registerDeath(index);
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
            ),
          ],
        ),
      ),
    );
  }
}