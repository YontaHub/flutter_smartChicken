
class Utilisateur {
  String nom;
  String email;
  String role;
  String telephone;
  String? uid; // Ajouté pour l'identifiant Firebase

  Utilisateur({
    required this.nom,
    required this.email,
    required this.role,
    required this.telephone,
    this.uid,
  });

  // Convertir en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'email': email,
      'role': role,
      'telephone': telephone,
    };
  }

  // Créer un Utilisateur à partir d'un document Firestore
  factory Utilisateur.fromMap(Map<String, dynamic> map, String uid) {
    return Utilisateur(
      nom: map['nom'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'fermier',
      telephone: map['telephone'] ?? '',
      uid: uid,
    );
  }
}