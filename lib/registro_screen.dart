import 'package:flutter/material.dart';
import 'package:preg1/DatabaseHelper.dart';
import 'package:preg1/main.dart';
import 'package:sqflite/sqflite.dart';

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  TextEditingController _tipoController = TextEditingController();
  TextEditingController _montoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Movimientos'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tipoController,
              decoration: InputDecoration(labelText: 'Tipo de movimiento'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _montoController,
              decoration: InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String tipo = _tipoController.text;
                double monto = double.parse(_montoController.text);

                if (tipo.isNotEmpty && monto > 0) {
                  Map<String, dynamic> row = {
                    DatabaseHelper.columnTipo: tipo,
                    DatabaseHelper.columnMonto: monto,
                  };

                  await DatabaseHelper.instance.insert(row);

                  _tipoController.clear();
                  _montoController.clear();

                  setState(() {});
                }
              },
              child: Text('Registrar movimiento'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/historial');
              },
              child: Text('Ver historial de movimientos'),
            ),
            SizedBox(height: 16.0),
            FutureBuilder<double>(
              future: DatabaseHelper.instance.getSaldo(),
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  double saldo = snapshot.data ?? 0;
                  return Text('Saldo: \$${saldo.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20.0));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}