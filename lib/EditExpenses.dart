import 'package:expensesapp/ExpensesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditExpenses extends StatefulWidget {
  final ExpensesModel _model;
  final int _index;

  EditExpenses(this._model, [this._index]);

  @override
  State<StatefulWidget> createState() => _EditExpensesState(_model, _index);
}

class _EditExpensesState extends State<EditExpenses> {
  var _format;
  bool _isAddExpense;
  double _price;
  String _name;
  DateTime _date;
  var _initialDate;
  var _selectedDay;
  TextEditingController _controller;
  ExpensesModel _model;
  int _index;

  _EditExpensesState(this._model, [this._index]);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<DateTime> _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2015),
        lastDate: DateTime(2101)
    );
    return picked;
  }

  @override
  void initState() {
    _format = DateFormat('yyyy-MM-dd');
    if (_index == null) {
      _isAddExpense = true;
      _initialDate = DateTime.now();
    } else {
      _isAddExpense = false;
      _selectedDay = _model.daysExpenses[_index];
      _initialDate = _selectedDay.date;
    }
    _date = _initialDate;
    _controller = TextEditingController(text: _format.format(_initialDate));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_isAddExpense ? "Add expense" : "Edit expense")
      ),
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
                initialValue: _isAddExpense ? "0" : _selectedDay.price.toString(),
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
                initialValue: _isAddExpense ? null : _selectedDay.name.toString(),
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
                      String formattedPick = _format.format(picked);
                      _controller.text = formattedPick;
                      _date = picked;
                    }
                  }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _isAddExpense ? _model.editExpenses(_name, _price, _date) : _model.editExpenses(_name, _price, _date, _selectedDay.id);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(_isAddExpense ? "Add" : "Edit"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

