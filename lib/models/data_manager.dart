import 'vaccin.dart';
import 'traitement.dart';
import 'vague.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  final List<Vaccin> _vaccins = [];
  final List<Traitement> _traitements = [];
  final List<Vague> _vagues = [];

  List<Vaccin> get vaccins => _vaccins;
  List<Traitement> get traitements => _traitements;
  List<Vague> get vagues => _vagues;

  void addVaccin(Vaccin vaccin) {
    _vaccins.add(vaccin);
  }

  void addTraitement(Traitement traitement) {
    _traitements.add(traitement);
  }

  void addVague(Vague vague) {
    _vagues.add(vague);
  }

  // Méthode pour récupérer le nom d'une vague par son ID
  String getVagueName(int vagueId) {
    try {
      final vague = _vagues.firstWhere((v) => v.vagueId == vagueId);
      return vague.nom;
    } catch (e) {
      // ignore: avoid_print
      print('Erreur dans getVagueName: vagueId $vagueId non trouvé, vagues: ${_vagues.map((v) => v.vagueId).toList()}'); // Débogage
      return 'Inconnu';
    }
  }
}