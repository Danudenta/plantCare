import 'package:flutter/foundation.dart';

import '../data/plant_repository.dart';

/// Status saklar simulasi offline untuk uji error jaringan.
class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel(this._repository);

  final PlantRepository _repository;

  bool get simulateOffline => _repository.simulateOffline;

  /// Mengaktifkan atau mematikan [PlantRepository.simulateOffline].
  void setSimulateOffline(bool value) {
    if (_repository.simulateOffline == value) return;
    _repository.simulateOffline = value;
    notifyListeners();
  }
}
