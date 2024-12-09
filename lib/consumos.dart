import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> refuelings = [];

  double getAverageConsumption() {
    if (refuelings.length < 2) return 0.0;

    double totalDistance = 0;
    double totalLiters = 0;

    for (int i = 1; i < refuelings.length; i++) {
      totalDistance += refuelings[i]['kilometers'] - refuelings[i - 1]['kilometers'];
      totalLiters += refuelings[i]['liters'];
    }

    return totalDistance / totalLiters;
  }

  void addRefueling(Map<String, dynamic> refueling) {
    setState(() {
      refuelings.add(refueling);
      refuelings.sort((a, b) => a['date'].compareTo(b['date']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ManutCar - Consumos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Consumo Médio: ${getAverageConsumption().toStringAsFixed(2)} km/L',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: refuelings.isEmpty
                  ? Text(
                      'Nenhum reabastecimento registrado',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  : ListView.builder(
                      itemCount: refuelings.length,
                      itemBuilder: (context, index) {
                        final refueling = refuelings[index];
                        return ListTile(
                          title: Text(
                              'Data: ${refueling['date'].day}/${refueling['date'].month}/${refueling['date'].year} - Km: ${refueling['kilometers']}'),
                          subtitle: Text(
                              'Litros: ${refueling['liters']} - Custo: ${refueling['cost']}€'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRefuelingPage(
                onSubmit: addRefueling,
                existingRefuelings: refuelings,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddRefuelingPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final List<Map<String, dynamic>> existingRefuelings;

  AddRefuelingPage({required this.onSubmit, required this.existingRefuelings});

  @override
  _AddRefuelingPageState createState() => _AddRefuelingPageState();
}

class _AddRefuelingPageState extends State<AddRefuelingPage> {
  final _formKey = GlobalKey<FormState>();
  final _kilometersController = TextEditingController();
  final _litersController = TextEditingController();
  final _costController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime? selectedDate;

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
        _dateController.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Reabastecimento'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Data',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: _pickDate,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione uma data';
                    }

                    if (widget.existingRefuelings.isNotEmpty && selectedDate != null) {
                      final latestDate = widget.existingRefuelings
                          .map((e) => e['date'] as DateTime)
                          .reduce((a, b) => a.isAfter(b) ? a : b);

                      if (selectedDate!.isBefore(latestDate)) {
                        return 'A data não pode ser anterior à última (${latestDate.day}/${latestDate.month}/${latestDate.year})';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _kilometersController,
                  decoration: InputDecoration(labelText: 'Quilometragem'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a quilometragem';
                    }

                    final double kilometers = double.tryParse(value) ?? -1.0;
                    if (kilometers < 0) {
                      return 'A quilometragem não pode ser negativa';
                    }

                    if (widget.existingRefuelings.isNotEmpty) {
                      final double maxKilometers = widget.existingRefuelings
                          .map((e) => e['kilometers'] as double)
                          .reduce((a, b) => a > b ? a : b);

                      if (kilometers < maxKilometers) {
                        return 'A quilometragem deve ser maior que a anterior (${maxKilometers.toStringAsFixed(2)} km)';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _litersController,
                  decoration: InputDecoration(labelText: 'Litros Abastecidos'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira os litros';
                    }

                    final double liters = double.tryParse(value) ?? -1.0;
                    if (liters < 0) {
                      return 'Os litros não podem ser negativos';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _costController,
                  decoration: InputDecoration(labelText: 'Custo (€)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o custo';
                    }

                    final double cost = double.tryParse(value) ?? -1.0;
                    if (cost < 0) {
                      return 'O custo não pode ser negativo';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit({
                        'date': selectedDate!,
                        'kilometers': double.parse(_kilometersController.text),
                        'liters': double.parse(_litersController.text),
                        'cost': double.parse(_costController.text),
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Adicionar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
