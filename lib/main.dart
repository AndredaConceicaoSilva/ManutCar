import 'package:flutter/material.dart';
import 'package:manutcar/user_provider.dart';
import 'consumos.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserProvider(
      child: MaterialApp(
        title: 'ManutCar',      
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false, // Remove o rótulo "Debug"
        home: MenuPage(),
      ),
    );
  }
}
 
class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Principal'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'ManutCar Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
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
          'Bem-vindo ao ManutCar!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
 