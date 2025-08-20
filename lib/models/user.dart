class Utilisateur {
  String nom;
  String email;
  String role;
  String telephone;

// Variable globale temporaire pour simuler l'utilisateur connecté (sans Firebase)
// À remplacer par un state management comme Provider ou Riverpod plus tard
// Utilisateur? currentUser;

  Utilisateur({
    required this.nom,
    required this.email,
    required this.role,
    required this.telephone,
  });

  // Méthode pour convertir en Map (utile plus tard avec Firebase)
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'email': email,
      'role': role,
      'telephone': telephone,
    };
  }
}