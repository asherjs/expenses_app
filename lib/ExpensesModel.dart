import 'package:expensesapp/Expense.dart';
import 'package:expensesapp/ExpenseDB.dart';
import 'package:expensesapp/MonthExpenses.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class ExpensesModel extends Model {
  var _format = DateFormat('dd MMMM yyyy');
  List<Expense> daysExpenses = [];
  List<MonthExpenses> monthsExpenses = [];

  ExpenseDB _database;

  int get dayRecordsCount => daysExpenses.length;
  int get monthRecordsCount => monthsExpenses.length;

  ExpensesModel() {
    _database = ExpenseDB();
    LoadMonthsExpenses();
    Load();
  }

  void LoadMonthsExpenses() {
    Future<List<MonthExpenses>> future = _database.getAllMonthExpenses();
    future.then((list) {
      monthsExpenses = list;
      notifyListeners();
    });
  }

  void Load() {
    Future<List<Expense>> future = _database.getAllExpenses();
    future.then((list) {
      daysExpenses = list;
      notifyListeners();
    });
  }

  int GetId(int index) {
    return daysExpenses[index].id;
  }

  String GetMonthExpensesText(int index) {
    var e = monthsExpenses[index];
    DateTime tempDate = new DateFormat("yyyy-MM").parse(e.date);
    String formatted = DateFormat("MMMM yyyy").format(tempDate);
    return e.expenses.toString() + "\n" + formatted;
  }

  String GetText(int index) {
    var e = daysExpenses[index];
    return e.name + " for " + e.price.toString() + "\n" + _format.format(e.date);
  }

  double GetTotalExpenses() {
    double result = 0;
    daysExpenses.forEach((e) => result += e.price);
    return result;
  }

  void RemoveAt(int index) {
    Future<void> future = _database.removeAt(index);
    future.then((_) {
      Load();
      LoadMonthsExpenses();
    });
  }

  void editExpenses(String name, double price, DateTime date, [int index]) {
    Future<void> future;
    if (index == null) {
       future = _database.editExpenses(name, price, date);
    } else {
      future = _database.editExpenses(name, price, date, index);
    }

    future.then((_) {
      Load();
      LoadMonthsExpenses();
    });
  }
}
