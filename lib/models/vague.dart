
class Vague {
  String nom;
  DateTime dateEnregistrement;
  int nombreVivant;
  int nombreMort;
  int nombreJours;
  final int vagueId; // Ajout d'un ID unique

  Vague({
    required this.nom,
    required this.dateEnregistrement,
    required this.nombreVivant,
    required this.nombreMort,
    required this.nombreJours,
    required DateTime dateArrivee,
    int? vagueId, // Optionnel pour permettre une génération automatique
  }) : vagueId = vagueId ?? DateTime.now().millisecondsSinceEpoch; // Générer un ID unique par défaut

  // Calcul de la date d'arrivée (dateEnregistrement + nombreJours)
  DateTime get dateArrivee => dateEnregistrement.add(Duration(days: nombreJours));
}