import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/providers/auth_state.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/utils/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _schoolController = TextEditingController();
  final _startYearController = TextEditingController();
  final _endYearController = TextEditingController();
  final _curriculumController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _school = '';
  String _startYear = '';
  String _endYear = '';
  String _curriculum = '';
  String _description = '';
  bool _isSubmitting = false;

  int get _latestReasonableYear => DateTime.now().year + 10;

  @override
  void dispose() {
    _schoolController.dispose();
    _startYearController.dispose();
    _endYearController.dispose();
    _curriculumController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateRequiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi.';
    }
    if (value.trim().length > 255) {
      return '$label maksimal 255 karakter.';
    }
    return null;
  }

  String? _validateYear(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi.';
    }

    final year = int.tryParse(value.trim());
    if (year == null) {
      return '$label harus berupa bilangan bulat.';
    }
    if (year < 1900 || year > _latestReasonableYear) {
      return 'Masukkan $label antara 1900 dan $_latestReasonableYear.';
    }

    final startYear = int.tryParse(_startYear.trim());
    final endYear = int.tryParse(_endYear.trim());
    if (label == 'Tahun Mulai' && endYear != null && year > endYear) {
      return 'Tahun Mulai tidak boleh melebihi Tahun Selesai.';
    }
    if (label == 'Tahun Selesai' && startYear != null && year < startYear) {
      return 'Tahun Selesai tidak boleh lebih awal dari Tahun Mulai.';
    }
    return null;
  }

  void _saveEducation() {
    if (_formKey.currentState?.validate() != true) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ringkasan Pendidikan'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SummaryItem(label: 'Nama Institusi', value: _school.trim()),
                _SummaryItem(label: 'Tahun Mulai', value: _startYear.trim()),
                _SummaryItem(label: 'Tahun Selesai', value: _endYear.trim()),
                _SummaryItem(label: 'Kurikulum', value: _curriculum.trim()),
                _SummaryItem(
                  label: 'Deskripsi Pendidikan',
                  value: _description.trim(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
          FilledButton.icon(
            onPressed: _isSubmitting
                ? null
                : () async {
                    Navigator.pop(dialogContext);
                    await _submitEducation();
                  },
            icon: const Icon(Icons.cloud_upload_outlined),
            label: const Text('Kirim ke server'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitEducation() async {
    final loggedIn = await ensureLoggedIn(context);
    if (!loggedIn || !mounted) return;

    final authState = context.read<AuthState>();
    final token = authState.token;
    if (token == null) return;

    setState(() => _isSubmitting = true);
    try {
      await context.read<ApiClient>().createEducation(
        token: token,
        school: _school.trim(),
        startYear: int.parse(_startYear.trim()),
        endYear: int.parse(_endYear.trim()),
        curriculum: _curriculum.trim(),
        description: _description.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pendidikan berhasil ditambahkan.')),
      );
      Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) authState.clearInvalidToken();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _fieldDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pendidikan'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _schoolController,
                  maxLength: 255,
                  textCapitalization: TextCapitalization.words,
                  decoration: _fieldDecoration('Nama Institusi / Sekolah'),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => _school = value,
                  validator: (value) =>
                      _validateRequiredText(value, 'Nama institusi'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _startYearController,
                  keyboardType: TextInputType.number,
                  decoration: _fieldDecoration(
                    'Tahun Mulai',
                    hint: 'Contoh: 2022',
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => _startYear = value,
                  validator: (value) => _validateYear(value, 'Tahun Mulai'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _endYearController,
                  keyboardType: TextInputType.number,
                  decoration: _fieldDecoration(
                    'Tahun Selesai',
                    hint: 'Contoh: 2025',
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => _endYear = value,
                  validator: (value) => _validateYear(value, 'Tahun Selesai'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _curriculumController,
                  maxLength: 255,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _fieldDecoration('Kurikulum'),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => _curriculum = value,
                  validator: (value) =>
                      _validateRequiredText(value, 'Kurikulum'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _fieldDecoration('Deskripsi Pendidikan'),
                  textInputAction: TextInputAction.newline,
                  onChanged: (value) => _description = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi pendidikan wajib diisi.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _saveEducation,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          SelectableText(value),
        ],
      ),
    );
  }
}
