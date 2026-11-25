import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/providers/auth_state.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  final String npm = "2506657213";
  final String nama = "Prajna Kausalya Damdami";
  final String kelas = "PBP F";
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, auth, _) {
        final items = [
          ItemHomepage("Lihat Proyek", Icons.folder, Colors.blue),
          ItemHomepage("Tambah Proyek", Icons.add_circle, Colors.green),
          ItemHomepage("Lihat Pendidikan", Icons.school_outlined, Colors.teal),
          ItemHomepage("Tambah Pendidikan", Icons.school, Colors.indigo),
          ItemHomepage(
            auth.isAuthenticated ? "Logout" : "Login",
            auth.isAuthenticated ? Icons.logout : Icons.login,
            Colors.red,
          ),
        ];

        return Scaffold(
          drawer: const LeftDrawer(),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'MyPortfolio',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 48) / 3;
              final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InfoCard(
                            title: 'NPM',
                            content: npm,
                            width: cardWidth,
                          ),
                        ),
                        Expanded(
                          child: InfoCard(
                            title: 'Nama',
                            content: nama,
                            width: cardWidth,
                          ),
                        ),
                        Expanded(
                          child: InfoCard(
                            title: 'Class',
                            content: kelas,
                            width: cardWidth,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Selamat datang di MyPortfolio Mobile!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 1.2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: items.map((item) => ItemCard(item)).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final double width;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}
