import 'package:flutter/material.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  const Calculator({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FirstScreen());
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _formKey = GlobalKey<FormState>();
  final _massController = TextEditingController();
  final _radiusController = TextEditingController();
  bool _agreement = false;

  @override
  void dispose() {
    _massController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Лопаткина Е. Е.')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _massController,
              decoration: InputDecoration(labelText: 'Масса небесного тела'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите массу небесного тела';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _radiusController,
              decoration: InputDecoration(labelText: 'Радиус небесного тела'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите радиус небесного тела';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            CheckboxListTile(
              title: Text('Согласие на обработку данных'),
              value: _agreement,
              onChanged: (value) {
                setState(() {
                  _agreement = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_agreement) {
                    double mass = double.parse(_massController.text);
                    double radius = double.parse(_radiusController.text);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondScreen(mass: mass, radius: radius),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Необходимо согласие на обработку данных',
                        ),
                      ),
                    );
                  }
                }
              },
              child: Text('Рассчитать'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final double mass;
  final double radius;

  SecondScreen({required this.mass, required this.radius});

  @override
  Widget build(BuildContext context) {
    const double G = 6.67430e-11;
    double result = (G * mass / radius);
    double cosmicVelocity = result > 0 ? result : 0;

    return Scaffold(
      appBar: AppBar(title: Text('Результат')),
      body: Center(
        child: Column(
          children: [
            Text('Первая космическая скорость ($mass, $radius) = $cosmicVelocity'),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirstScreen()),
                );
              },
              child: Text('Вернуться'),
            ),
          ],
        ),
      ),
    );
  }
}