import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ajouté
import '../models/vaccin.dart';

class PlanVaccinScreen extends StatefulWidget {
  final int vagueId;

  const PlanVaccinScreen({super.key, required this.vagueId});

  @override
  PlanVaccinScreenState createState() => PlanVaccinScreenState();
}

class PlanVaccinScreenState extends State<PlanVaccinScreen> {
  final _formKey = GlobalKey<FormState>();
  String nomVaccin = '';
  DateTime? dateVaccination = DateTime.now();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newVaccin = Vaccin(
        nom: nomVaccin,
        dateVaccination: dateVaccination!,
        vagueId: widget.vagueId,
        dateInitiation: DateTime.now(), // Ajout de la date d'initiation
      );
      try {
        await FirebaseFirestore.instance.collection('vaccins').add(newVaccin.toMap());
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vaccin $nomVaccin enregistré avec succès pour la vague ${widget.vagueId}')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, newVaccin);
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
      appBar: AppBar(title: Text('Planifier un Vaccin')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom du vaccin', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Entrez un nom' : null,
                onSaved: (value) => nomVaccin = value ?? '',
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date de vaccination',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: dateVaccination!.toString().split(' ')[0],
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: dateVaccination ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => dateVaccination = picked);
                  }
                },
                validator: (value) => dateVaccination == null ? 'Choisissez une date' : null,
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