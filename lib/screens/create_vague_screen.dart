import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ajouté pour Firestore
import '../models/vague.dart';

class CreateVagueScreen extends StatefulWidget {
  const CreateVagueScreen({super.key});

  @override
  CreateVagueScreenState createState() => CreateVagueScreenState();
}

class CreateVagueScreenState extends State<CreateVagueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  DateTime? dateEnregistrement = DateTime.now();
  final _vivantController = TextEditingController();
  final _mortController = TextEditingController();
  final _joursController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vous devez être connecté pour créer une vague')),
          );
          setState(() => _isLoading = false);
          return;
        }

        final newVague = Vague(
          nom: _nomController.text.trim(),
          dateEnregistrement: dateEnregistrement!,
          nombreVivant: int.parse(_vivantController.text.trim()),
          nombreMort: int.parse(_mortController.text.trim()),
          nombreJours: int.parse(_joursController.text.trim()),
          userId: user.uid, // ID de l'utilisateur connecté
        );

        // Ajout de la vague dans Firestore
        await FirebaseFirestore.instance.collection('vagues').add(newVague.toMap());
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vague "${newVague.nom}" enregistrée avec succès')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, newVague); // Retourne la vague pour mise à jour dans VaguesTab
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'enregistrement: $e')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _vivantController.dispose();
    _mortController.dispose();
    _joursController.dispose();
    super.dispose();
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
                              controller: _nomController,
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
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: dateEnregistrement!.toString().split(' ')[0],
                              ),
                              decoration: InputDecoration(
                                labelText: 'Date d\'enregistrement',
                                prefixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: dateEnregistrement ?? DateTime.now(),
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
                              controller: _vivantController,
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
                                if (val + (int.tryParse(_mortController.text) ?? 0) < 0) {
                                  return 'Incohérent avec les morts';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _mortController,
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
                                if (val + (int.tryParse(_vivantController.text) ?? 0) < 0) {
                                  return 'Incohérent avec les vivants';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _joursController,
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
                            ),
                            SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: _isLoading
                                      ? Center(child: CircularProgressIndicator())
                                      : ElevatedButton(
                                          onPressed: _submitForm,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green[700],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0)),
                                            padding: EdgeInsets.symmetric(vertical: 16.0),
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
                                          borderRadius: BorderRadius.circular(8.0)),
                                      padding: EdgeInsets.symmetric(vertical: 16.0),
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