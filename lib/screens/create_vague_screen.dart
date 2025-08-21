import 'package:flutter/material.dart';
import '../models/vague.dart';

class CreateVagueScreen extends StatefulWidget {
  const CreateVagueScreen({super.key});

  @override
  CreateVagueScreenState createState() => CreateVagueScreenState();
}

class CreateVagueScreenState extends State<CreateVagueScreen> {
  final _formKey = GlobalKey<FormState>();
  String nomVague = '';
  DateTime? dateEnregistrement = DateTime.now();
  int nombreVivant = 0;
  int nombreMort = 0;
  int nombreJours = 0;
  late int nombreTotal;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      nombreTotal = nombreVivant - nombreMort;
      final newVague = Vague(
        nom: nomVague,
        dateEnregistrement: dateEnregistrement!,
        nombreVivant: nombreVivant,
        nombreMort: nombreMort,
        nombreJours: nombreJours,
      );
      Navigator.pop(context, newVague); // Retourne la vague créée
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    elevation: 6.0,
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Créer une vague',
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Remplissez les détails pour enregistrer une nouvelle vague',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 24.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nom',
                                prefixIcon: Icon(Icons.title),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrez un nom';
                                }
                                return null;
                              },
                              onSaved: (value) => nomVague = value ?? '',
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Date d\'enregistrement',
                                prefixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                text:
                                    dateEnregistrement.toString().split(' ')[0],
                              ),
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      dateEnregistrement ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => dateEnregistrement = picked);
                                }
                              },
                              validator: (value) {
                                if (dateEnregistrement == null) {
                                  return 'Choisissez une date';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nombre vivants',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrez un nombre';
                                }
                                int? val = int.tryParse(value);
                                if (val == null) return 'Doit être un nombre';
                                if (val + nombreMort < 0) {
                                  return 'Incohérent avec les morts';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  nombreVivant = int.parse(value ?? '0'),
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nombre morts',
                                prefixIcon: Icon(Icons.remove_circle),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrez un nombre';
                                }
                                int? val = int.tryParse(value);
                                if (val == null) return 'Doit être un nombre';
                                if (val + nombreVivant < 0) {
                                  return 'Incohérent avec les vivants';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  nombreMort = int.parse(value ?? '0'),
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nombre de jours',
                                prefixIcon: Icon(Icons.calendar_view_day),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrez un nombre';
                                }
                                int? val = int.tryParse(value);
                                if (val == null) return 'Doit être un nombre';
                                if (val < 0) return 'Doit être positif';
                                return null;
                              },
                              onSaved: (value) =>
                                  nombreJours = int.parse(value ?? '0'),
                            ),
                            SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[700],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.0),
                                    ),
                                    child: Text('Enregistrer',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.0),
                                    ),
                                    child: Text('Annuler',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
