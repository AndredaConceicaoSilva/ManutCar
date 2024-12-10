import 'package:flutter/material.dart';
import 'consumos.dart'; // Certifique-se de importar o arquivo consumos.dart

class MenuPage extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página Principal'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu Lateral',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Consumos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Bem-vindo á ManutCar',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
