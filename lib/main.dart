import 'package:flutter/material.dart';
import 'components/transaction_form.dart';
import 'models/transaction.dart';
import 'components/transaction_list.dart';
import 'dart:math';

void main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  final _transactions = [
    Transaction(id: "t1", title: "Tenis", value: 310, date: DateTime.now()),
    Transaction(id: "t2", title: "Conta", value: 50.15, date: DateTime.now()),
  ];

  _addTransaction(String title, double value){
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: DateTime.now()
    );
    setState((){
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Despesas Pessoais"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Card(
                color: Colors.greenAccent,
                child: Text("Grafico"),
                elevation: 10,
              ),
            ),
            TransactionList(_transactions),
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
