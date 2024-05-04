import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wheel_picker/wheel_picker.dart';

import 'crowd_prediction.dart';
class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
DateTime today = DateTime.now();
TimeOfDay selectedTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
DateTime selectedDate = DateTime.now();
String selectedHour = DateTime.now().hour.toString();
String selectedMints = DateTime.now().minute.toString();
String selectedSecond = DateTime.now().second.toString();
String selectedMeridiem = 'AM';


  selectedTimeWheel(int itemCount ,   Function(int index) onIndexChange , int initialIndex){
  return  WheelPicker(
      builder: (context, index) {
        return Text('$index',style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.grey.shade500),);
      },
      itemCount: itemCount,
      initialIndex:initialIndex,
      looping: true,
      selectedIndexColor: Colors.white,

      onIndexChanged: onIndexChange,
      style: const WheelPickerStyle(
        size: 120,
        squeeze: 1,
        itemExtent: 35,
      ));
}

  Widget timePicker(){
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        selectedTimeWheel(24 ,   (index) {
          selectedHour = index.toString();
        }, DateTime.now().hour),
        Text(' : ',style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),),
        selectedTimeWheel(60 ,   (index) {
          selectedMints = index.toString();
        }, DateTime.now().minute),
        Text(' : ',style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),),
        selectedTimeWheel(60 ,   (index) {
          selectedSecond = index.toString();
        }, DateTime.now().second),
        const SizedBox(width: 50,),
        WheelPicker(
          itemCount: 2,
          selectedIndexColor: Colors.white,

          builder: (context, index) {
            return Text(["AM", "PM"][index],  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.grey.shade500),);
          },
          initialIndex: (TimeOfDay.now().period == DayPeriod.am) ? 0 : 1,
          looping: false,
          onIndexChanged: (index){
            if(index == 0){
            selectedMeridiem = 'AM';
          }else{
    selectedMeridiem = 'PM';
    }},
    style: const WheelPickerStyle(
      size: 120,
    squeeze: 2,
    itemExtent: 45,
    ),
    ),
      ],
    );
  }


  Widget selectionButtons(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        GestureDetector(
          child: Container(
              padding:  EdgeInsets.only(
                  left: 60.w
                  ,right: 60.w,
                top: 5.h,
                bottom: 5.h
              ),

              margin:  EdgeInsets.only(
              bottom: 10.h ,right: 20.w  ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.green.shade700
                  ),
                color: Colors.green[700]
              ),
              child: Text('save',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
              )),
          onTap: (){
            Map selectedDateAndTime = {
              'time' : '$selectedHour : $selectedMints : $selectedSecond : $selectedMeridiem',
              'date' : selectedDate
            };
            selectedTime = TimeOfDay(hour: int.parse(selectedHour.toString()) , minute: int.parse(selectedMints.toString()));
            Navigator.push(context,MaterialPageRoute(builder: (context)=>  CrowdPrediction(userTimeAndDate: selectedDateAndTime, selectedTime: selectedTime,)));
          },
        ),
      ],
    );
  }


  Widget calender(){
  return TableCalendar(

    daysOfWeekHeight: 20,
    daysOfWeekStyle: DaysOfWeekStyle(

      weekdayStyle: TextStyle(
        color: Colors.grey.shade400
      ),
      weekendStyle: TextStyle(
          color: Colors.grey.shade400
      ),
    ),
      calendarStyle: CalendarStyle(

          todayDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 2
                  , color: Colors.deepPurpleAccent
              ),
              color: Colors.deepPurpleAccent
          ),

          defaultDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          weekendDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          todayTextStyle: const TextStyle(
              color: Colors.white
          ),
          selectedDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                width: 2,
                color: Colors.deepPurpleAccent
            ),
          ),
          selectedTextStyle: const TextStyle(
              color: Colors.deepPurpleAccent
          ),
      ),
      focusedDay: today,
      headerStyle:  HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        headerPadding: EdgeInsets.all(3),
        decoration: BoxDecoration(
         // color: Colors.green,
          border: Border(
            bottom: BorderSide(
              width: 3.w,
              color: Colors.grey.shade300,
            )
          )
        )
      ),
      onDaySelected: _onDaySelected,
      selectedDayPredicate: (day){
        return today ==  day;
      },
      firstDay: DateTime(2020),
      lastDay: DateTime(2025));
  }

  _onDaySelected(DateTime day , DateTime focusedDay){
    setState(() {
      today = day;
      selectedDate = day;
    });
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
            child: calender(),
          ),
       Container(
         margin: const EdgeInsets.symmetric(horizontal: 10,
         vertical: 20
       ),
         padding: const EdgeInsets.symmetric(
     vertical: 10,
    horizontal: 10),
       decoration: BoxDecoration(
           color: Colors.black,
         borderRadius: BorderRadius.circular(10)
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text('SetTime',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white,fontSize:15,fontWeight: FontWeight.w700),),
           timePicker(),
           const SizedBox(
             height: 10,
           ),
           selectionButtons()
         ],
       )
     )
        ],
      )
    );
  }
}
