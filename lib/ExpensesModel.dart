import 'package:expensesapp/Expense.dart';
import 'package:expensesapp/ExpenseDB.dart';
import 'package:expensesapp/MonthExpenses.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class ExpensesModel extends Model {
  static var _format = DateFormat('dd MMMM yyyy');
  //static var _yyyyMMformat = DateFormat('yyyy-MM');
  List<Expense> _daysExpenses = [
//    Expense(1, '2022-10-12', "Car", 1000),
//    Expense(2, '2022-06-8', "Food", 645),
//    Expense(3, '2022-03-7', "Stuff", 788),
  ];
  List<MonthExpenses> _monthsExpenses = [];

  ExpenseDB _database;

  int get dayRecordsCount => _daysExpenses.length;
  int get monthRecordsCount => _monthsExpenses.length;

  ExpensesModel() {
    _database = ExpenseDB();
    LoadMonthsExpenses();
    Load();
  }

  void LoadMonthsExpenses() {
    Future<List<MonthExpenses>> future = _database.getAllMonthExpenses();
    future.then((list) {
      _monthsExpenses = list;
      notifyListeners();
    });
  }

  void Load() {
    Future<List<Expense>> future = _database.getAllExpenses();
    future.then((list) {
      _daysExpenses = list;
      notifyListeners();
    });
  }

  int GetId(int index) {
    return _daysExpenses[index].id;
  }

  String GetMonthExpensesText(int index) {
    var e = _monthsExpenses[index];
    DateTime tempDate = new DateFormat("yyyy-MM").parse(e.date);
    String formatted = DateFormat("MMMM yyyy").format(tempDate);
    return e.expenses.toString() + "\n" + formatted;
  }

  String GetText(int index) {
    var e = _daysExpenses[index];
    //if(e.date != "null" && e.date != null) return e.name + " for " + e.price.toString() + "\n" + e.date.toString();
    return e.name + " for " + e.price.toString() + "\n" + _format.format(e.date);
  }

  double GetTotalExpenses() {
    double result = 0;
    _daysExpenses.forEach((e) => result += e.price);
    return result;
  }

  void RemoveAt(int index) {
    Future<void> future = _database.removeAt(index);
    future.then((_) {
      Load();
      LoadMonthsExpenses();
    });
  }

  void addExpense(String name, double price, DateTime date) {
    Future<void> future = _database.addExpense(name, price, date);
    future.then((_) {
      Load();
      LoadMonthsExpenses();
    });
  }

  void getTable() {
    _database.getTable();
  }
}
