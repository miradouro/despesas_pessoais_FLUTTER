import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {

  final void Function(String, double) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {

  final titleController = TextEditingController();
  final valueController = TextEditingController();

  _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;
    if(title.isEmpty || value <= 0.0){
      return;
    }
    widget.onSubmit(title, value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              onSubmitted: (_) => _submitForm(),
              decoration: InputDecoration(
                labelText: "Titulo",
              ),
            ),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: valueController,
              onSubmitted: (_) => _submitForm(),
              decoration: InputDecoration(
                labelText: "Valor (R\$)",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                  onPressed: _submitForm,
                  child: Text("Nova Despesa"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
