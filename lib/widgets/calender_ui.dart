
import 'package:flutter/material.dart';
import 'package:hamroghar/model/app_constants.dart';

class CalenderUi extends StatefulWidget {

  int? monthIndex;
  List<DateTime>? bookedDates;
  Function? selectDate;
  Function? getSelectedDates;

  CalenderUi({
    super.key,
    this.monthIndex,this.bookedDates,this.selectDate,this.getSelectedDates

  });

  @override
  State<CalenderUi> createState() => _CalenderUiState();
}

class _CalenderUiState extends State<CalenderUi> {

  List<DateTime> _selectedDates = [];
  List<MonthTileWidget> _mothTiles =[];
  int? _currentMonthInt;
  int? _currentYearInt;

  _setUpMothTiles(){
    _mothTiles = [];
    int daysInMonth = AppConstants.daysInMonths[_currentMonthInt]!;
    DateTime firstDayOfMonth = DateTime(_currentYearInt!,_currentMonthInt!,1);
    int firstWeekOfMonth = firstDayOfMonth.weekday;

    if(firstWeekOfMonth != 7){
      for(int i = 0 ; i < firstWeekOfMonth ; i++){
        _mothTiles.add(MonthTileWidget(dateTime: null,));
      }
    }
    for(int i = 0 ; i < daysInMonth ; i++){
      DateTime date = DateTime(_currentYearInt!,_currentYearInt!,i + 1);
      _mothTiles.add(MonthTileWidget(dateTime: date,));
    }
  }

  _selectDate(DateTime date){
    if(_selectedDates.contains(date)){
      _selectedDates.remove(date);
    }else{
      _selectedDates.add(date);
    }
    widget.selectDate!(date);
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentMonthInt = (DateTime.now().month + widget.monthIndex!) % 12;
    if(_currentMonthInt == 0){
      _currentMonthInt =12;
    }
    _currentYearInt =DateTime.now().year;
    if(_currentMonthInt! < DateTime.now().month){
      _currentYearInt = _currentYearInt! + 1;
    }
    _selectedDates.sort();
    _selectedDates.addAll(widget.getSelectedDates!());
    _setUpMothTiles();

  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(bottom: 20.0),
        child: Text(
          "${AppConstants.monthDec[_currentMonthInt]} - $_currentYearInt ",
        ),
        ),
        GridView.builder(
          itemCount: _mothTiles.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio:  1 / 1,
          ),
          itemBuilder: (context,index){
            MonthTileWidget monthTile = _mothTiles[index];
            if(monthTile.dateTime == null){
              return MaterialButton(
                onPressed: null,
                child: Text(""),
              );
            }
            if(widget.bookedDates!.contains((monthTile.dateTime))){
              return MaterialButton(
                onPressed: null,
                color: Colors.yellow,
                disabledColor: Colors.yellow,
                child: monthTile,
              );
            }

            return MaterialButton(
              onPressed: (){
                _selectDate(monthTile.dateTime!);
              },
              color: (_selectedDates.contains(monthTile.dateTime))
                  ? Colors.blue : Colors.white,
              child: monthTile,

            );
          },
        ),
      ],
    );
  }
}


class MonthTileWidget extends StatelessWidget {
  DateTime? dateTime;

  MonthTileWidget({super.key,this.dateTime});

  @override
  Widget build(BuildContext context) {
    return  Text(
      dateTime == null ? "" : dateTime!.day.toString(),
      style: TextStyle(
        fontSize: 14,
      ),
    );
  }
}

