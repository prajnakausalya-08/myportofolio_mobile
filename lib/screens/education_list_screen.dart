import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/providers/auth_state.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class EducationListScreen extends StatefulWidget {
  const EducationListScreen({super.key});

  @override
  State<EducationListScreen> createState() => _EducationListScreenState();
}

class _EducationListScreenState extends State<EducationListScreen> {
  late Future<List<Education>> _educations;

  @override
  void initState() {
    super.initState();
    _educations = _fetchEducations();
  }

  Future<List<Education>> _fetchEducations() {
    final token = context.read<AuthState>().token;
    return context.read<ApiClient>().getEducations(token: token);
  }

  Future<void> _refresh() async {
    final future = _fetchEducations();
    setState(() => _educations = future);
    try {
      await future;
    } on ApiException {
      // The FutureBuilder displays the error state after the refresh.
    }
  }

  Future<void> _openAddForm() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const EducationFormPage()),
    );
    if (saved == true) await _refresh();
  }

  Widget _messageList({required Widget child, VoidCallback? onRetry}) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        Center(child: child),
        if (onRetry != null) ...[
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendidikan'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddForm,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pendidikan'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Education>>(
          future: _educations,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return _messageList(child: const CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              if (snapshot.error is ApiException &&
                  (snapshot.error! as ApiException).statusCode == 401 &&
                  context.read<AuthState>().isAuthenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) context.read<AuthState>().clearInvalidToken();
                });
              }
              final message = snapshot.error is ApiException
                  ? (snapshot.error! as ApiException).message
                  : 'Data pendidikan tidak dapat dimuat.';
              return _messageList(
                child: Text(message, textAlign: TextAlign.center),
                onRetry: _refresh,
              );
            }

            final educations = snapshot.data ?? const <Education>[];
            if (educations.isEmpty) {
              return _messageList(
                child: const Text('Belum ada data pendidikan.'),
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: educations.length,
              itemBuilder: (context, index) =>
                  _EducationCard(education: educations[index]),
            );
          },
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({required this.education});

  final Education education;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              education.school,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('${education.startYear} – ${education.endYear}'),
            const SizedBox(height: 8),
            Text('Kurikulum: ${education.curriculum}'),
            const SizedBox(height: 8),
            Text(education.description),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star_outline, size: 18),
                const SizedBox(width: 4),
                Text('${education.starCount} star'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
