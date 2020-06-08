import 'package:expensesapp/ExpensesModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

enum WidgetMarker {day, month}

class BodyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BodyWidgetState();
}

class BodyWidgetState extends State<BodyWidget>  {
  WidgetMarker selectedWidgetMarker = WidgetMarker.day;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                setState(() {
                  selectedWidgetMarker = WidgetMarker.day;
                });
              },
              child: Text("Day", style: TextStyle(color: Colors.black45),),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  selectedWidgetMarker = WidgetMarker.month;
                });
              },
              child: Text("Month", style: TextStyle(color: Colors.black45),),
            ),
          ],
        ),
            Expanded(
              child: ScopedModelDescendant<ExpensesModel>(
                  builder: (context, child, model) => ListView.separated(
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListTile(
                          title: Text("Total Expenses: " + model.GetTotalExpenses().toString()),
                          onTap: () {
                            //model.getTable();
                            //model.GetMonthsExpenses();
                          },
                        );
                      } else {
                        index -= 1;
                        return getCustomContainer(index);
                      }
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: selectedWidgetMarker == WidgetMarker.day ? model.dayRecordsCount + 1 : model.monthRecordsCount + 1,
                    //model.dayRecordsCount + 1,
                  )
              ),
            ),
      ],
    );
  }
//
  Widget getCustomContainer(index) {
    switch (selectedWidgetMarker) {
      case WidgetMarker.day:
        return getDaysExpensesWidget(index);
      case WidgetMarker.month:
        return getMonthsExpensesWidget(index);
    }
    return getDaysExpensesWidget(index);
  }

  Widget getDaysExpensesWidget(index) {
    return ScopedModelDescendant<ExpensesModel>(
      builder: (context, child, model) => Dismissible(
          key: Key(model.GetId(index).toString()),
          onDismissed: (direction) {
            model.RemoveAt(model.GetId(index));
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("deleted record $index"))
            );
          },
          child: ListTile(
            title: Text(model.GetText(index)),
            leading: Icon(Icons.attach_money),
            trailing: Icon(Icons.delete),
            onLongPress: () {

            },
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
            );}
      ),
    );
  }

  Widget getMonthsExpensesWidget(index) {
    return ScopedModelDescendant<ExpensesModel>(
      builder: (context, child, model) => ListTile(
        title: Text(model.GetMonthExpensesText(index)),
        leading: Icon(Icons.attach_money),
      ),
    );
  }
}