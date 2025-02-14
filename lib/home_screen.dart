import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'planet.dart';
import 'planet_detail_screen.dart';
import 'planet_form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Planet>> futurePlanets;

  @override
  void initState() {
    super.initState();
    futurePlanets = DatabaseHelper().planets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planetas'),
      ),
      body: FutureBuilder<List<Planet>>(
        future: futurePlanets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum planeta cadastrado.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final planet = snapshot.data![index];
                return ListTile(
                  title: Text(planet.name),
                  subtitle: Text(planet.nickname ?? ''),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlanetDetailScreen(planet: planet),
                    ),
                  ).then((_) {
                    setState(() {
                      futurePlanets = DatabaseHelper().planets();
                    });
                  }),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanetFormScreen(),
            ),
          );
          setState(() {
            futurePlanets = DatabaseHelper().planets();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
