
class Vaccin {
  final String nom;
  final DateTime dateVaccination;
  final int vagueId; // ID de la vague associée
  final DateTime dateInitiation; // Date de création/initiation

  Vaccin({
    required this.nom,
    required this.dateVaccination,
    required this.vagueId,
    DateTime? dateInitiation,
  }) : dateInitiation = dateInitiation ?? DateTime.now();
}