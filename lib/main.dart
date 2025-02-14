import 'edit_planet_screen.dart';
import 'planet_details_screen.dart';
import 'delete_confirmation_dialog.dart';

// ...

class _PlanetListScreenState extends State<PlanetListScreen> {
  // ...

  void _navigateToEditPlanetScreen([Planet? planet]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPlanetScreen(planet: planet)),
    );
    if (result == true) {
      _refreshPlanetList();
    }
  }

  void _showPlanetDetails(Planet planet) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlanetDetailsScreen(planet: planet)),
    );
  }

  void _confirmDeletePlanet(int id) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        onDelete: () async {
          await _dbHelper.deletePlanet(id);
          _refreshPlanetList();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planets'),
      ),
      body: ListView.builder(
        itemCount: _planets.length,
        itemBuilder: (context, index) {
          final planet = _planets[index];
          return ListTile(
            title: Text(planet.name),
            subtitle: Text(planet.nickname ?? ''),
            onTap: () {
              _showPlanetDetails(planet);
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _confirmDeletePlanet(planet.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToEditPlanetScreen();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
