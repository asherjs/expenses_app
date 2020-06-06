import 'package:expensesapp/ExpensesModel.dart';
import 'package:flutter/material.dart';

class _AddExpenseState extends State<AddExpense> {
  double _price;
  String _name;
  DateTime _date = DateTime.now();
  ExpensesModel _model;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _AddExpenseState(this._model);

  final _controller = TextEditingController(text: DateTime.now().toString());

  Future<DateTime> _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2015),
        lastDate: DateTime(2101)
    );
    //if(picked != null) setState(() => _date = picked);
    return picked;
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add expense")),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money),
                    labelText: "Money"
                ),
                autovalidate: true,
                autocorrect: true,
                initialValue: "0",
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (double.tryParse(value) != null) {
                    return null;
                  } else {
                    return "Enter the valid price";
                  }
                },
                onSaved: (value) {
                  _price = double.parse(value);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: "Name"
                ),
                onSaved: (value) {
                  _name = value;
                },
                validator: (value) {
                  if (String != null) {
                    return null;
                  } else {
                    return "Enter the valid name";
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    icon: Icon(Icons.date_range),
                    labelText: "Date"
                ),
                controller: _controller,
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime picked = await _selectDate();
                  if (picked != null) {
                    _controller.text = picked.toString();
                    _date = picked;
                  }
                }
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _model.addExpense(_name, _price, _date);
                    Navigator.pop(context);
                  }
                },
                child: Text("Add"),
              )
            ],
          ),
        ),
      )
    );
  }
}

class AddExpense extends StatefulWidget {
  final ExpensesModel _model;

  AddExpense(this._model);

  @override
  State<StatefulWidget> createState() => _AddExpenseState(_model);
}
