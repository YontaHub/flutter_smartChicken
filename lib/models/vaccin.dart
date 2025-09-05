import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Vaccin {
  final String nom;
  final DateTime dateVaccination;
  final int vagueId; // ID de la vague associée
  final DateTime dateInitiation; // Date de création/initiation
  final String? id; // ID Firestore (optionnel, pour fromMap)

  Vaccin({
    required this.nom,
    required this.dateVaccination,
    required this.vagueId,
    DateTime? dateInitiation,
    this.id,
  }) : dateInitiation = dateInitiation ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'dateVaccination': Timestamp.fromDate(dateVaccination),
      'vagueId': vagueId,
      'dateInitiation': Timestamp.fromDate(dateInitiation),
      'userId': FirebaseAuth.instance.currentUser?.uid ?? '', // Ajout pour filtrer par utilisateur
    };
  }

  static Vaccin fromMap(Map<String, dynamic> data, String id) {
    return Vaccin(
      nom: data['nom'] as String,
      dateVaccination: (data['dateVaccination'] as Timestamp).toDate(),
      vagueId: data['vagueId'] as int,
      dateInitiation: (data['dateInitiation'] as Timestamp).toDate(),
      id: id,
    );
  }
}