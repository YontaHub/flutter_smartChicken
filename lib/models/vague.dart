import 'package:cloud_firestore/cloud_firestore.dart';

class Vague {
  final String nom;
  final DateTime dateEnregistrement;
  int nombreVivant;
  int nombreMort;
  final int nombreJours;
  final String? vagueId; // ID Firestore, nullable car généré par Firestore
  final String userId; // Nouvel attribut pour l'ID de l'utilisateur

  Vague({
    required this.nom,
    required this.dateEnregistrement,
    required this.nombreVivant,
    required this.nombreMort,
    required this.nombreJours,
    this.vagueId, // ID sera fourni par Firestore lors de l'ajout
    required this.userId, // ID de l'utilisateur connecté
  });

  // Calcul de la date d'arrivée (dateEnregistrement + nombreJours)
  DateTime get dateArrivee => dateEnregistrement.add(Duration(days: nombreJours));

  // Convertir l'objet en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'dateEnregistrement': Timestamp.fromDate(dateEnregistrement),
      'nombreVivant': nombreVivant,
      'nombreMort': nombreMort,
      'nombreJours': nombreJours,
      'userId': userId, // Ajout de l'ID de l'utilisateur dans le document
    };
  }

  // Créer un Vague à partir d'un Map Firestore
  factory Vague.fromMap(Map<String, dynamic> map, String id) {
    return Vague(
      nom: map['nom'] ?? '',
      dateEnregistrement: (map['dateEnregistrement'] as Timestamp).toDate(),
      nombreVivant: map['nombreVivant'] ?? 0,
      nombreMort: map['nombreMort'] ?? 0,
      nombreJours: map['nombreJours'] ?? 0,
      vagueId: id, // ID du document Firestore
      userId: map['userId'] ?? '', // Récupérer l'ID de l'utilisateur
    );
  }
}