import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'planet.dart';

class PlanetFormScreen extends StatefulWidget {
  final Planet? planet;

  PlanetFormScreen({this.planet});

  @override
  _PlanetFormScreenState createState() => _PlanetFormScreenState();
}

class _PlanetFormScreenState extends State<PlanetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _distanceFromSun;
  late double _size;
  String? _nickname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.planet == null ? 'Adicionar Planeta' : 'Editar Planeta'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.planet?.name,
                decoration: InputDecoration(labelText: 'Nome do Planeta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome.';
                  }
                  _name = value;
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.planet?.distanceFromSun.toString(),
                decoration: InputDecoration(labelText: 'Distância do Sol (em UA)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma distância.';
                  }
                  _distanceFromSun = double.parse(value);
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.planet?.size.toString(),
                decoration: InputDecoration(labelText: 'Tamanho (em km)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um tamanho.';
                  }
                  _size = double.parse(value);
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.planet?.nickname,
                decoration: InputDecoration(labelText: 'Apelido'),
                onSaved: (value) {
                  _nickname = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newPlanet = Planet(
                      id: widget.planet?.id ?? 0,
                      name: _name,
                      distanceFromSun: _distanceFromSun,
                      size: _size,
                      nickname: _nickname,
                    );
                    if (widget.planet == null) {
                      await DatabaseHelper().insertPlanet(newPlanet);
                    } else {
                      await DatabaseHelper().updatePlanet(newPlanet);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.planet == null ? 'Adicionar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
