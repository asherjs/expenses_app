import 'dart:io';
import 'package:expensesapp/Expense.dart';
import 'package:expensesapp/MonthExpenses.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDB {
  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialize();
    }
    return _database;
  }

  ExpenseDB();

  initialize() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    var path = join(documentsDir.path, "db.db");
    return openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, price REAL, date TEXT, name TEXT)");
      }
    );
  }

  Future<List<MonthExpenses>> getAllMonthExpenses() async {
    Database db = await database;
    List<Map> query = await db.rawQuery("SELECT id, SUM(price) as \"month-expenses\", strftime(\"%Y-%m\", date) as \"date\" FROM Expenses GROUP BY strftime(\"%Y-%m\", date) ORDER BY date DESC");
    var result = List<MonthExpenses>();
    query.forEach((r) {
      result.add(MonthExpenses(r["id"], r["date"], r["month-expenses"]));
    });
    return result;
  }

  Future<List<Expense>> getAllExpenses() async {
    Database db = await database;
    List<Map> query = await db.rawQuery("SELECT * FROM Expenses ORDER BY date DESC");
    var result = List<Expense>();
    query.forEach((r) => {
      result.add(Expense(r["id"], DateTime.parse(r["date"]), r["name"], r["price"]))
    });
    return result;
  }

  Future<void> removeAt(int index) async {
    Database db = await database;
    await db.rawDelete("DELETE FROM Expenses WHERE id = $index");
  }

//  Future<void> addExpense(String name, double price, DateTime dateTime) async {
//    Database db = await database;
//    String stringDateTime = dateTime.toString();
//
//  }

  Future<void> editExpenses(String name, double price, DateTime dateTime, [int index]) async {
    Database db = await database;
    String stringDateTime = dateTime.toString();
    if (index == null) {
      await db.rawInsert("INSERT INTO Expenses (name, date, price) VALUES (\"$name\",\"$stringDateTime\", $price)");
    } else {
      await db.rawInsert("UPDATE Expenses SET name=\"$name\", date=\"$stringDateTime\", price=$price WHERE id=$index");
    }
  }

}