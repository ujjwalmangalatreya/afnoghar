import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamroghar/global.dart';
import 'package:hamroghar/model/posting_model.dart';
import 'package:hamroghar/payment_gateway/paymnet_config.dart';
import 'package:hamroghar/view/guest_home_screen.dart';
import 'package:hamroghar/widgets/calender_ui.dart';
import 'package:pay/pay.dart';

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
    for(int i = 0 ; i < 12 ; i ++){
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


  _makeBooking(){
    if(selectedDates.isEmpty){
      return ;
    }
    posting!.makeNewBooking(selectedDates,context).whenComplete((){
      Get.back();

    });

  }

  calculateAmountForOverAllStay(){
    if(selectedDates.isEmpty){
      return ;
    }
    int totalPriceForAllNights = (selectedDates.length * posting!.price!) ;
    bookingPrice = totalPriceForAllNights;
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
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: 20,),
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: (calendarWidgets.isEmpty) ? Container() :
                PageView.builder(
                  itemCount: calendarWidgets.length,
                  itemBuilder: (context,index){
                    return calendarWidgets[index];
                  },

                ),
              ),
            ),

            bookingPrice == 0.0 ? MaterialButton(
              onPressed: (){
                calculateAmountForOverAllStay();
              },
              minWidth: double.infinity,
              height: MediaQuery.of(context).size.height / 14,
              color: Colors.green,
              child: Text("Proceed",
                style: TextStyle(color: Colors.white),),
            ) : Container(),

            paymentResults != ""
                ? MaterialButton(
              onPressed: (){Get.to(()=>GuestHomeScreen());
                setState(() {
                  paymentResults = "";
                });
                },
              minWidth: double.infinity,
              height: MediaQuery.of(context).size.height / 14,
              color: Colors.green,
              child: Text("Amount Paid Successfully !",
              style: TextStyle(color: Colors.white),),
            )
                : Container(),

            bookingPrice == 0.0 ? Container() :
            Platform.isIOS
                ? ApplePayButton(
              paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
              paymentItems: [
                PaymentItem(
                    amount: bookingPrice.toString(),
                    label: "Booking Amount",
                  status: PaymentItemStatus.final_price
                )
              ],
              style: ApplePayButtonStyle.black,
              width: double.infinity,
              height: 50,
              type: ApplePayButtonType.buy,
              margin: EdgeInsets.only(top: 15.0),
              onPaymentResult: (result) {
                print(result);
                setState(() {
                  paymentResults = result.toString();

                });
                _makeBooking();

              },
              loadingIndicator: Center(child: CircularProgressIndicator(),),
            )
                : GooglePayButton(
              paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
              paymentItems: [
                PaymentItem(
                    amount: bookingPrice.toString(),
                    label: "Total Amount",
                    status: PaymentItemStatus.final_price
                )
              ],
              type: GooglePayButtonType.pay,
              margin: EdgeInsets.only(top: 15.0),
              onPaymentResult: (result) {
                print(result);
                setState(() {
                  paymentResults = result.toString();

                });
                _makeBooking();

              },
              loadingIndicator: Center(child: CircularProgressIndicator(),),
            ),
          ],
        ),
      ),
    );
  }
}
