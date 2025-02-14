import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'planet.dart';

class EditPlanetScreen extends StatefulWidget {
  final Planet? planet;

  EditPlanetScreen({this.planet});

  @override
  _EditPlanetScreenState createState() => _EditPlanetScreenState();
}

class _EditPlanetScreenState extends State<EditPlanetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.planet != null) {
      _nameController.text = widget.planet!.name;
      _distanceController.text = widget.planet!.distanceFromSun.toString();
      _sizeController.text = widget.planet!.size.toString();
      _nicknameController.text = widget.planet!.nickname ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.planet == null ? 'Add Planet' : 'Edit Planet'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Planet Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the planet name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _distanceController,
                decoration: InputDecoration(labelText: 'Distance from Sun (AU)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid distance';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(labelText: 'Size (km)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid size';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: 'Nickname (optional)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final name = _nameController.text;
                    final distance = double.parse(_distanceController.text);
                    final size = double.parse(_sizeController.text);
                    final nickname = _nicknameController.text;

                    final planet = Planet(
                      id: widget.planet?.id ?? 0,
                      name: name,
                      distanceFromSun: distance,
                      size: size,
                      nickname: nickname,
                    );

                    if (widget.planet == null) {
                      _dbHelper.insertPlanet(planet);
                    } else {
                      _dbHelper.updatePlanet(planet);
                    }

                    Navigator.pop(context, true);
                  }
                },
                child: Text(widget.planet == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
