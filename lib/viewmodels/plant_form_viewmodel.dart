import 'package:flutter/foundation.dart';

import '../data/models/plant.dart';
import '../data/plant_repository.dart';
import '../utils/date_utils.dart';
import '../utils/validators.dart';

/// Field form yang bisa memiliki pesan error.
enum FormField { name, species, location, interval, notes }

/// State isian form tambah atau edit.
@immutable
class PlantFormUiState {
  const PlantFormUiState({
    this.name = '',
    this.species = '',
    this.location = '',
    this.category = PlantCategory.indoor,
    this.emoji = '🌿',
    this.intervalText = '',
    this.notes = '',
    this.errors = const {},
    this.isSaving = false,
  });

  final String name;
  final String species;
  final String location;
  final PlantCategory category;
  final String emoji;
  final String intervalText;
  final String notes;
  final Map<FormField, String> errors;
  final bool isSaving;

  PlantFormUiState copyWith({
    String? name,
    String? species,
    String? location,
    PlantCategory? category,
    String? emoji,
    String? intervalText,
    String? notes,
    Map<FormField, String>? errors,
    bool? isSaving,
  }) {
    return PlantFormUiState(
      name: name ?? this.name,
      species: species ?? this.species,
      location: location ?? this.location,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      intervalText: intervalText ?? this.intervalText,
      notes: notes ?? this.notes,
      errors: errors ?? this.errors,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

/// State dan validasi form tanaman. Satu instance untuk satu layar form.
class PlantFormViewModel extends ChangeNotifier {
  PlantFormViewModel(this._repository);

  final PlantRepository _repository;

  PlantFormUiState _state = const PlantFormUiState();
  PlantFormUiState _baseline = const PlantFormUiState();
  int? _editingId;
  bool _notFound = false;
  bool _saving = false;
  String? _pendingMessage;

  PlantFormUiState get state => _state;
  bool get isEditing => _editingId != null;
  bool get notFound => _notFound;
  String? get pendingMessage => _pendingMessage;

  /// True bila isian berbeda dari data saat form dibuka.
  bool get isDirty =>
      _state.name != _baseline.name ||
      _state.species != _baseline.species ||
      _state.location != _baseline.location ||
      _state.category != _baseline.category ||
      _state.emoji != _baseline.emoji ||
      _state.intervalText != _baseline.intervalText ||
      _state.notes != _baseline.notes;

  /// [plantId] <= 0 membuka mode tambah. Id yang tidak ada menandai notFound.
  void load(int plantId) {
    if (plantId <= 0) {
      _editingId = null;
      _notFound = false;
      _state = const PlantFormUiState();
      _baseline = _state;
      notifyListeners();
      return;
    }

    final plant = _repository.getById(plantId);
    if (plant == null) {
      _editingId = null;
      _notFound = true;
      notifyListeners();
      return;
    }

    _editingId = plant.id;
    _notFound = false;
    _state = PlantFormUiState(
      name: plant.name,
      species: plant.species,
      location: plant.location,
      category: plant.category,
      emoji: plant.emoji,
      intervalText: '${plant.wateringIntervalDays}',
      notes: plant.notes,
    );
    _baseline = _state;
    notifyListeners();
  }

  void updateName(String value) =>
      _update(FormField.name, validatePlantName(value), name: value);

  void updateSpecies(String value) =>
      _update(FormField.species, validateSpecies(value), species: value);

  void updateLocation(String value) =>
      _update(FormField.location, validateLocation(value), location: value);

  void updateInterval(String value) => _update(
        FormField.interval,
        validateWateringInterval(value),
        intervalText: value,
      );

  void updateNotes(String value) =>
      _update(FormField.notes, validateNotes(value), notes: value);

  void updateCategory(PlantCategory value) {
    _state = _state.copyWith(category: value);
    notifyListeners();
  }

  void updateEmoji(String value) {
    _state = _state.copyWith(emoji: value);
    notifyListeners();
  }

  /// Menyimpan form. Gagal diam-diam bila masih ada error atau klik ganda.
  Future<bool> save() async {
    if (_saving || _state.isSaving) return false;
    if (_notFound) {
      _pendingMessage = 'Gagal menyimpan. Silakan coba lagi.';
      notifyListeners();
      return false;
    }

    final errors = _collectErrors();
    if (errors.isNotEmpty) {
      _state = _state.copyWith(errors: errors);
      notifyListeners();
      return false;
    }

    _saving = true;
    _state = _state.copyWith(isSaving: true, errors: const {});
    notifyListeners();
    // Melepas giliran agar klik kedua melihat flag penyimpanan.
    await Future<void>.delayed(Duration.zero);

    final saved = _writePlant();
    _saving = false;
    _state = _state.copyWith(isSaving: false);
    if (saved) _baseline = _state;
    notifyListeners();
    return saved;
  }

  /// Mengambil pesan sekali pakai agar SnackBar tidak muncul ulang.
  String? consumeMessage() {
    final message = _pendingMessage;
    _pendingMessage = null;
    return message;
  }

  void _update(
    FormField field,
    String? error, {
    String? name,
    String? species,
    String? location,
    String? intervalText,
    String? notes,
  }) {
    _state = _state.copyWith(
      name: name,
      species: species,
      location: location,
      intervalText: intervalText,
      notes: notes,
      errors: _errorsWith(field, error),
    );
    notifyListeners();
  }

  Map<FormField, String> _errorsWith(FormField field, String? error) {
    final next = Map<FormField, String>.of(_state.errors);
    if (error == null) {
      next.remove(field);
    } else {
      next[field] = error;
    }
    return next;
  }

  Map<FormField, String> _collectErrors() {
    final errors = <FormField, String>{};
    void put(FormField field, String? error) {
      if (error != null) errors[field] = error;
    }

    put(FormField.name, validatePlantName(_state.name));
    put(FormField.species, validateSpecies(_state.species));
    put(FormField.location, validateLocation(_state.location));
    put(FormField.interval, validateWateringInterval(_state.intervalText));
    put(FormField.notes, validateNotes(_state.notes));
    return errors;
  }

  bool _writePlant() {
    final interval = int.tryParse(_state.intervalText.trim());
    if (interval == null) {
      _pendingMessage = 'Gagal menyimpan. Silakan coba lagi.';
      return false;
    }

    final existing = _editingId == null ? null : _repository.getById(_editingId!);
    if (_editingId != null && existing == null) {
      _notFound = true;
      _pendingMessage = 'Gagal menyimpan. Silakan coba lagi.';
      return false;
    }

    final draft = Plant(
      id: existing?.id ?? 0,
      name: _state.name.trim(),
      species: _state.species.trim(),
      category: _state.category,
      location: _state.location.trim(),
      emoji: _state.emoji,
      wateringIntervalDays: interval,
      lastWateredDate: existing?.lastWateredDate ?? dateOnly(DateTime.now()),
      notes: _state.notes.trim(),
      isFavorite: existing?.isFavorite ?? false,
    );

    if (existing == null) {
      _repository.add(draft);
      _pendingMessage = 'Tanaman berhasil ditambahkan';
      return true;
    }

    final updated = _repository.update(draft);
    _pendingMessage = updated
        ? 'Perubahan disimpan'
        : 'Gagal menyimpan. Silakan coba lagi.';
    return updated;
  }
}
