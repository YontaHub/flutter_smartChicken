import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ajouté
import '../models/traitement.dart';

class PlanTraitementScreen extends StatefulWidget {
  final int vagueId;

  const PlanTraitementScreen({super.key, required this.vagueId});

  @override
  PlanTraitementScreenState createState() => PlanTraitementScreenState();
}

class PlanTraitementScreenState extends State<PlanTraitementScreen> {
  final _formKey = GlobalKey<FormState>();
  String nomTraitement = '';
  DateTime? dateDebut = DateTime.now();
  DateTime? dateFin = DateTime.now().add(Duration(days: 7));

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (dateFin!.isBefore(dateDebut!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La date de fin doit être après la date de début')),
        );
        return;
      }
      final newTraitement = Traitement(
        nom: nomTraitement,
        dateDebut: dateDebut!,
        dateFin: dateFin!,
        vagueId: widget.vagueId,
        dateInitiation: DateTime.now(), // Ajout de la date d'initiation
      );
      try {
        await FirebaseFirestore.instance.collection('traitements').add(newTraitement.toMap());
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Traitement $nomTraitement enregistré avec succès pour la vague')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, newTraitement);
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'enregistrement: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Planifier un Traitement')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom du traitement', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Entrez un nom' : null,
                onSaved: (value) => nomTraitement = value ?? '',
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date de début',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: dateDebut!.toString().split(' ')[0],
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: dateDebut ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => dateDebut = picked);
                  }
                },
                validator: (value) => dateDebut == null ? 'Choisissez une date' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date de fin',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: dateFin!.toString().split(' ')[0],
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: dateFin ?? DateTime.now().add(Duration(days: 7)),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => dateFin = picked);
                  }
                },
                validator: (value) => dateFin == null ? 'Choisissez une date' : null,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}