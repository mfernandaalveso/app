import 'package:flutter/material.dart';
import 'planet.dart';

class PlanetDetailsScreen extends StatelessWidget {
  final Planet planet;

  PlanetDetailsScreen({required this.planet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planet.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${planet.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Distance from Sun: ${planet.distanceFromSun} AU', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Size: ${planet.size} km', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            if (planet.nickname != null && planet.nickname!.isNotEmpty)
              Text('Nickname: ${planet.nickname}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
