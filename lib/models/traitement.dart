import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Traitement {
  final String nom;
  final DateTime dateDebut;
  final DateTime dateFin;
  final int vagueId; // ID de la vague associée
  final DateTime dateInitiation; // Date de création/initiation
  final String? id; // ID Firestore (optionnel, pour fromMap)

  Traitement({
    required this.nom,
    required this.dateDebut,
    required this.dateFin,
    required this.vagueId,
    DateTime? dateInitiation,
    this.id,
  }) : dateInitiation = dateInitiation ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'dateDebut': Timestamp.fromDate(dateDebut),
      'dateFin': Timestamp.fromDate(dateFin),
      'vagueId': vagueId,
      'dateInitiation': Timestamp.fromDate(dateInitiation),
      'userId': FirebaseAuth.instance.currentUser?.uid ?? '', // Ajout pour filtrer par utilisateur
    };
  }

  static Traitement fromMap(Map<String, dynamic> data, String id) {
    return Traitement(
      nom: data['nom'] as String,
      dateDebut: (data['dateDebut'] as Timestamp).toDate(),
      dateFin: (data['dateFin'] as Timestamp).toDate(),
      vagueId: data['vagueId'] as int,
      dateInitiation: (data['dateInitiation'] as Timestamp).toDate(),
      id: id,
    );
  }
}