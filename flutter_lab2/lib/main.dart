import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Лопаткина Е.Е.')),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Text('ВАРИАНТ 5', style: TextStyle(fontSize: 50)),

            Wrap(
              spacing: 8.0,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.amber,
                  child: Text('ФИО: Лопаткина Екатерина Евгеньевна'),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.amber,
                  child: Text('Дата рождения: 11 апреля 2004 г.'),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.amber,
                  child: Text('Специальность: Информационные системы и технологии в управлении'),
                ),
              ],
            ),
          ],
        ),
    );
  }
}
