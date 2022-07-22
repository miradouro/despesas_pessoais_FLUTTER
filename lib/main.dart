import 'dart:ffi';

import 'package:flutter/material.dart';
import 'components/chart.dart';
import 'components/transaction_form.dart';
import 'models/transaction.dart';
import 'components/transaction_list.dart';
import 'dart:math';
import 'package:flutter/services.dart';

void main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

    final ThemeData tema = ThemeData();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.orange,
          secondary: Colors.amber,
        ),
        textTheme: tema.textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  final List<Transaction> _transactions = [
    // Transaction(
    //     id: "t1",
    //     title: "Bill",
    //     value: 10,
    //     date: DateTime.now().subtract(Duration(days: 33))),
    // Transaction(
    //     id: "t1",
    //     title: "Tenis",
    //     value: 210,
    //     date: DateTime.now().subtract(Duration(days: 3))),
    // Transaction(
    //     id: "t2",
    //     title: "Conta",
    //     value: 150.15,
    //     date: DateTime.now().subtract(Duration(days: 4))),
    // Transaction(
    //     id: "t3",
    //     title: "Bill",
    //     value: 10,
    //     date: DateTime.now().subtract(Duration(days: 33))),
    // Transaction(
    //     id: "t4",
    //     title: "Tenis",
    //     value: 210,
    //     date: DateTime.now().subtract(Duration(days: 3))),
    // Transaction(
    //     id: "t5",
    //     title: "Conta",
    //     value: 150.15,
    //     date: DateTime.now().subtract(Duration(days: 4))),
    // Transaction(
    //     id: "t6",
    //     title: "Bill",
    //     value: 10,
    //     date: DateTime.now().subtract(Duration(days: 33))),
    // Transaction(
    //     id: "t7",
    //     title: "Tenis",
    //     value: 210,
    //     date: DateTime.now().subtract(Duration(days: 3))),
    // Transaction(
    //     id: "t8",
    //     title: "Conta",
    //     value: 150.15,
    //     date: DateTime.now().subtract(Duration(days: 4))),
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );
    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {

    bool islandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(
        "Despesas Pessoais",
      ),
      centerTitle: true,
      actions: <Widget>[
        if(islandscape)
          IconButton(
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
            icon: Icon(_showChart ? Icons.list : Icons.pie_chart),
          ),
        IconButton(
          onPressed: () => _openTransactionFormModal(context),
          icon: Icon(Icons.add),
        ),
      ],
    );

    final avaliableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(islandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Exibir Grafico"),
                  Switch.adaptive(
                    activeColor: Colors.green,
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    },
                  ),
                ],
              ),
            if (_showChart || !islandscape)
              Container(
                height: avaliableHeight * (islandscape ? 0.7 : 0.3),
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !islandscape)
              Container(
                height: avaliableHeight * (islandscape ? 0.9 : 0.7),
                child: TransactionList(
                  _transactions,
                  _removeTransaction,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
