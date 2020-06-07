import 'package:expensesapp/Expense.dart';
import 'package:expensesapp/ExpenseDB.dart';
import 'package:scoped_model/scoped_model.dart';

class ExpensesModel extends Model {

  List<Expense> _items = [
//    Expense(1, DateTime.now(), "Car", 1000),
//    Expense(2, DateTime.now(), "Food", 645),
//    Expense(3, DateTime.now(), "Stuff", 788),
  ];
  ExpenseDB _database;

  int get recordsCount => _items.length;

  ExpensesModel() {
    _database = ExpenseDB();
    Load();
  }

  void Load() {
    Future<List<Expense>> future = _database.getAllExpenses();
    future.then((list) {
      _items = list;
      notifyListeners();
    });
  }

  int GetId(int index) {
    return _items[index].id;
  }

  String GetText(int index) {
    var e = _items[index];
    //if(e.date != "null" && e.date != null) return e.name + " for " + e.price.toString() + "\n" + e.date.toString();
    return e.name + " for " + e.price.toString() + "\n" + e.date.toString();
  }

  double GetTotalExpenses() {
    double result = 0;
    _items.forEach((e) => result += e.price);
    return result;
  }

  void RemoveAt(int index) {
    Future<void> future = _database.removeAt(index);
    future.then((_) {
      Load();
    });
  }

  void addExpense(String name, double price, DateTime date) {
    Future<void> future = _database.addExpense(name, price, date);
    future.then((_) {
      Load();
    });
  }

  void getTable() {
    _database.getTable();
  }
}

//Flutter 4 - 29:22