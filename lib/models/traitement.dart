
class Traitement {
  final String nom;
  final DateTime dateDebut;
  final DateTime dateFin;
  final int vagueId; // ID de la vague associée
  final DateTime dateInitiation; // Date de création/initiation

  Traitement({
    required this.nom,
    required this.dateDebut,
    required this.dateFin,
    required this.vagueId,
    DateTime? dateInitiation,
  }) : dateInitiation = dateInitiation ?? DateTime.now();
}