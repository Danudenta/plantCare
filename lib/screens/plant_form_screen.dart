import 'package:flutter/material.dart' hide FormField;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app/app_messenger.dart';
import '../app/theme/app_colors.dart';
import '../data/models/plant.dart';
import '../data/plant_repository.dart';
import '../viewmodels/plant_form_viewmodel.dart';
import '../widgets/app_text_field.dart';
import '../widgets/error_state.dart';

const List<String> plantEmojis = ['🌿', '🌵', '🌸', '🍀', '🪴', '🌳', '🌺', '🌻'];

/// Form tambah atau edit. State isian dipegang ViewModel layar ini.
class PlantFormScreen extends StatefulWidget {
  const PlantFormScreen({super.key, required this.plantId});

  /// Nilai <= 0 berarti mode tambah.
  final int plantId;

  @override
  State<PlantFormScreen> createState() => _PlantFormScreenState();
}

class _PlantFormScreenState extends State<PlantFormScreen> {
  late final PlantFormViewModel _form;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _species = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _interval = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  var _askingDiscard = false;

  @override
  void initState() {
    super.initState();
    _form = PlantFormViewModel(context.read<PlantRepository>());
    _form.load(widget.plantId);
    _name.text = _form.state.name;
    _species.text = _form.state.species;
    _location.text = _form.state.location;
    _interval.text = _form.state.intervalText;
    _notes.text = _form.state.notes;
  }

  @override
  void dispose() {
    _form.dispose();
    _name.dispose();
    _species.dispose();
    _location.dispose();
    _interval.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final saved = await _form.save();
    final message = _form.consumeMessage();
    if (!mounted) return;
    if (message != null) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
    if (saved) context.pop();
  }

  Future<void> _maybeLeave() async {
    if (!_form.isDirty) {
      context.pop();
      return;
    }
    if (_askingDiscard) return;
    _askingDiscard = true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Buang perubahan?'),
          content: const Text('Perubahan yang belum disimpan akan hilang.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Buang'),
            ),
          ],
        );
      },
    );
    _askingDiscard = false;
    if (discard == true && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _form,
      builder: (context, _) {
        if (_form.notFound) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Tanaman')),
            body: ErrorState(
              message: 'Tanaman tidak ditemukan',
              actionLabel: 'Kembali',
              onRetry: () => context.pop(),
            ),
          );
        }

        final state = _form.state;
        return PopScope(
          canPop: !_form.isDirty,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _maybeLeave();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(_form.isEditing ? 'Edit Tanaman' : 'Tambah Tanaman'),
            ),
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      AppTextField(
                        controller: _name,
                        label: 'Nama',
                        errorText: state.errors[FormField.name],
                        textInputAction: TextInputAction.next,
                        onChanged: _form.updateName,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _species,
                        label: 'Jenis',
                        errorText: state.errors[FormField.species],
                        textInputAction: TextInputAction.next,
                        onChanged: _form.updateSpecies,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _location,
                        label: 'Lokasi',
                        errorText: state.errors[FormField.location],
                        textInputAction: TextInputAction.next,
                        onChanged: _form.updateLocation,
                      ),
                      const SizedBox(height: 16),
                      Text('Kategori', style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      SegmentedButton<PlantCategory>(
                        segments: [
                          for (final category in PlantCategory.values)
                            ButtonSegment(
                              value: category,
                              label: Text(category.label),
                            ),
                        ],
                        selected: {state.category},
                        onSelectionChanged: (value) {
                          _form.updateCategory(value.first);
                        },
                      ),
                      const SizedBox(height: 16),
                      Text('Emoji', style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 56,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: plantEmojis.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final emoji = plantEmojis[index];
                            final selected = emoji == state.emoji;
                            return Tooltip(
                              message: 'Pilih emoji $emoji',
                              child: InkWell(
                                onTap: () => _form.updateEmoji(emoji),
                                borderRadius: BorderRadius.circular(28),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selected
                                        ? AppColors.primaryContainer
                                        : AppColors.surface,
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.onSurface.withValues(alpha: 0.25),
                                      width: selected ? 2 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    emoji,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _interval,
                        label: 'Interval siram',
                        helperText: 'dalam hari',
                        errorText: state.errors[FormField.interval],
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: _form.updateInterval,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _notes,
                        label: 'Catatan',
                        errorText: state.errors[FormField.notes],
                        maxLines: 4,
                        maxLength: 200,
                        textInputAction: TextInputAction.newline,
                        onChanged: _form.updateNotes,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: state.isSaving ? null : _save,
                        child: state.isSaving
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            : const Text('Simpan'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: state.isSaving ? null : _maybeLeave,
                        child: const Text('Batal'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
