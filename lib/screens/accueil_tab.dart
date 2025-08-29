import 'package:flutter/material.dart';
import '../screens/create_vague_screen.dart';
import '../widgets/card_widget.dart';
import '../models/data_manager.dart';
import '../models/vague.dart';
import 'chat_screen.dart'; // Nouvelle page de chat

class AccueilTab extends StatelessWidget {
  final Function()? onDataUpdated;

  const AccueilTab({super.key, this.onDataUpdated});

  @override
  Widget build(BuildContext context) {
    final data = {
      'vaguesActives': {'count': DataManager().vagues.length},
      'totalSujets': {'count': 12450},
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
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateVagueScreen()),
                        );
                        if (result != null && result is Vague) {
                          DataManager().addVague(result);
                          if (onDataUpdated != null) {
                            onDataUpdated!();
                          }
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
  }
}