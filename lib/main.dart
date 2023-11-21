import 'package:flutter/material.dart';
import 'package:preg1/registro_screen.dart';
import 'package:preg1/historial_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Ingresos y Egresos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => RegistroScreen(),
        '/historial': (context) => HistorialScreen(),
      },
    );
  }
}










/*import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Database _database;
  TextEditingController _amountController = TextEditingController();
  double _balance = 0.0;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'finance.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY, amount REAL, type TEXT)',
        );
      },
      version: 1,
    );

    _updateBalance();
  }

  Future<void> _updateBalance() async {
    List<Map<String, dynamic>> transactions = await _database.query('transactions');
    double totalIncome = 0.0;
    double totalExpense = 0.0;

    transactions.forEach((transaction) {
      double amount = transaction['amount'];
      String type = transaction['type'];

      if (type == 'income') {
        totalIncome += amount;
      } else {
        totalExpense += amount;
      }
    });

    setState(() {
      _balance = totalIncome - totalExpense;
    });
  }

  Future<void> _insertTransaction(double amount, String type) async {
    await _database.insert(
      'transactions',
      {'amount': amount, 'type': type},
    );

    _updateBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finanzas Personales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Saldo: \$$_balance',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Monto'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    double amount = double.tryParse(_amountController.text) ?? 0.0;
                    if (amount > 0) {
                      _insertTransaction(amount, 'income');
                    }
                  },
                  child: Text('Ingreso'),
                ),
                ElevatedButton(
                  onPressed: () {
                    double amount = double.tryParse(_amountController.text) ?? 0.0;
                    if (amount > 0 && amount <= _balance) {
                      _insertTransaction(amount, 'expense');
                    }
                  },
                  child: Text('Egreso'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/










/*import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Finanzas',
      home: FinanceApp(),
    );
  }
}

class FinanceApp extends StatefulWidget {
  @override
  _FinanceAppState createState() => _FinanceAppState();
}

class _FinanceAppState extends State<FinanceApp> {
  late Database _database;
  TextEditingController _amountController = TextEditingController();
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  void _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'finance_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY, type TEXT, amount REAL)',
        );
      },
      version: 1,
    );
    _updateTransactionsList();
  }

  void _updateTransactionsList() async {
    final List<Map<String, dynamic>> transactions = await _database.query('transactions');
    setState(() {
      _transactions = transactions;
    });
  }

  void _addTransaction(String type, double amount) async {
    await _database.insert(
      'transactions',
      {'type': type, 'amount': amount},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _updateTransactionsList();
  }

  double _calculateBalance() {
    double income = 0;
    double expenses = 0;

    for (var transaction in _transactions) {
      if (transaction['type'] == 'income') {
        income += transaction['amount'];
      } else {
        expenses += transaction['amount'];
      }
    }

    return income - expenses;
  }

  void _handleTransaction(String type) {
    double amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      // Validación para asegurarse de que la cantidad sea mayor que cero.
      return;
    }

    if (type == 'expense' && amount > _calculateBalance()) {
      // Validación para asegurarse de que los egresos no sean mayores que los ingresos.
      return;
    }

    _addTransaction(type, amount);
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Finanzas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Monto'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _handleTransaction('income'),
                  child: Text('Ingreso'),
                ),
                ElevatedButton(
                  onPressed: () => _handleTransaction('expense'),
                  child: Text('Egreso'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Saldo: \$${_calculateBalance()}'),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${_transactions[index]['type']} \$${_transactions[index]['amount']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
