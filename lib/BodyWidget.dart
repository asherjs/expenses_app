import 'package:expensesapp/ExpensesModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'main.dart';

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Container(child: getCustomContainer())
      ],
    );
  }

  Widget getCustomContainer() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.day:
        return getDaysExpensesWidget();
      case WidgetMarker.month:
        return getMonthsExpensesWidget();
    }
    return getDaysExpensesWidget();
  }

  Widget getDaysExpensesWidget() {
    return Expanded(
      child: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => ListView.separated(
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  title: Text("Total Expenses: " + model.GetTotalExpenses().toString()),
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
                );
              }
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: model.recordsCount + 1,
          )
      ),
    );
  }

  Widget getMonthsExpensesWidget() {
    return Container(
      height: 300,
      color: Colors.green,
    );
  }
}