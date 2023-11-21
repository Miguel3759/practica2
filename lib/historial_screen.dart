import 'package:flutter/material.dart';
import 'package:preg1/Databasehelper.dart';
import 'package:preg1/main.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:preg1/main.dart';

class HistorialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Movimientos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.queryAllRows(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> rows = snapshot.data ?? [];
            return ListView.builder(
              itemCount: rows.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> row = rows[index];
                return ListTile(
                  title: Text(row[DatabaseHelper.columnTipo]),
                  subtitle: Text('\$${row[DatabaseHelper.columnMonto]}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}