import 'package:flutter/material.dart';
import 'package:hamroghar/model/posting_model.dart';
import 'package:hamroghar/widgets/calender_ui.dart';

class BookListingScreen extends StatefulWidget {

  PostingModel? posting;
  BookListingScreen({super.key,this.posting});

  @override
  State<BookListingScreen> createState() => _BookListingScreenState();
}

class _BookListingScreenState extends State<BookListingScreen> {

  PostingModel? posting;
  List<DateTime> bookedDates =[];
  List<DateTime> selectedDates =[];
  List<CalenderUi> calendarWidgets = [];
  
  _buildCalenderWidgets(){
    for(int i = 0 ; i < 12 ;i ++){
      calendarWidgets.add(CalenderUi(
        monthIndex: i,
        bookedDates: bookedDates,
        selectDate: _selectDate,
        getSelectedDates: _getSelectedDate,
      ),
      );
      setState(() {

      });
    }
  }

  List<DateTime> _getSelectedDate(){
    return selectedDates;
  }

  _selectDate(DateTime date){
    if(selectedDates.contains(date)){
      selectedDates.remove(date);
    }else{
      selectedDates.add(date);
    }
    selectedDates.sort();
    setState(() {
    });
  }

  _loadBookedDates(){
    posting!.getAllBookingFromDatabase().whenComplete((){
      bookedDates = posting!.getAllBookedDates();
      _buildCalenderWidgets();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    posting = widget.posting;
    _loadBookedDates();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pinkAccent,
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0,0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          'Book ${posting!.name}',

        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Sun"),
                Text("Mon"),
                Text("Tue"),
                Text("Wed"),
                Text("Thru"),
                Text("Fri"),
                Text("Sat"),
              ],
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height /2,
              child: (calendarWidgets.isEmpty) ? Container() :
              PageView.builder(
                itemCount: calendarWidgets.length,
                itemBuilder: (context,index){
                  return calendarWidgets[index];
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}
