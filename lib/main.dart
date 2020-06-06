import 'package:expensesapp/AddExpense.dart';
import 'package:expensesapp/ExpensesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpensesModel>(
      model: ExpensesModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => ListView.separated(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: Text("Total expenses: " + model.GetTotalExpenses().toString()),
                  );
                } else {
                  index -= 1;
                  return Dismissible(
                    key: Key(model.GetId(index).toString()),
                    onDismissed: (direction) {
                      //model.getTable();
                      model.RemoveAt(model.GetId(index));
                      Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("deleted record $index"))
                      );
                    },
                    child: ListTile(
                      title: Text(model.GetText(index)),
                      leading: Icon(Icons.attach_money),
                      trailing: Icon(Icons.delete),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm"),
                            content: Text("Are you sure?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text("Delete")
                              ),
                              FlatButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text("Cancel")
                              ),
                            ],
                          );
                        }
                      );
                    },
                  );
                }
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: model.recordsCount + 1
          ),
        ),
        floatingActionButton: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddExpense(model);
                  }
                )
              );
            },
            child: Icon(Icons.add)
          ),
        ),
      ),
    );
  }
}

