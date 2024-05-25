import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../Components/loader.dart';
import '../api_services.dart';
import '../model_class/calculate_data.dart';
import '../model_class/count_data.dart';

class CrowdPrediction extends StatefulWidget {
  final Map userTimeAndDate;
  final TimeOfDay selectedTime;
  const CrowdPrediction({ required this.userTimeAndDate,required this.selectedTime  ,super.key});

  @override
  State<CrowdPrediction> createState() => _CrowdPredictionState();
}

class _CrowdPredictionState extends State<CrowdPrediction> {
  final apiService = ApiServices();
  bool isLoading = false;
  var myFormat = DateFormat('yyyy-MM-dd') ;
  String userSelectedDate = "" ;
  String userSelectedTime = "" ;
  List<String> options = [
    'Actual crowd registered ', 'Predicted crowding level'];
  int selectedIndex = 0;
  List<BarChartGroupData> bcd = [];
late  GetCount countData ;
  CalculateData? predictedCount;
  @override
  void initState() {
    print(widget.selectedTime.hour);
    getArticles();
    super.initState();
  }
  void getArticles() async{
    isLoading = true;
    String date = myFormat.format(widget.userTimeAndDate['date']).toString();
    var response =  await apiService.getNewsData(date);
    userSelectedDate = date;
    userSelectedTime = widget.userTimeAndDate['time'];
    countData = response;
    listOfSpots (true);
      isLoading = false;
    setState(() {
    });
  }

  void getPredictedCrowed() async{
    isLoading = true;
    String date = myFormat.format(widget.userTimeAndDate['date']).toString();
   Map<String,dynamic> predictedDate = {
      "date": date
  };
   print(predictedDate);
    var response =  await apiService.getListOfCrowd(predictedDate);
    userSelectedDate = date;
    userSelectedTime = widget.userTimeAndDate['time'];
    predictedCount = response;
    listOfSpots (false);
      isLoading = false;
    setState(() {
    });
  }

  String actualNumberOfUser(){
   String userCount = '';
   if(countData.visitCounts[widget.selectedTime.hour.toString()] != null){
     userCount =  countData.visitCounts[widget.selectedTime.hour.toString()].toString();
   }else{
     userCount = '0';
   }
    return userCount;
  }

  String isPmOrAm(){
   String meridiem = '';
if(widget.selectedTime.period == DayPeriod.pm){
  meridiem = 'PM';
}else{
  meridiem = 'AM';
}
    return meridiem;
  }

  String predictedNumberOfUser(){
   String userCount = '';
   try{
     userCount = predictedCount!.data[widget.selectedTime.hour.toString()].toString();
   }catch(e){
     userCount = "0";
   };
    return userCount;
  }


  void register() async{
    isLoading = true;
    String date = myFormat.format(widget.userTimeAndDate['date']).toString();
   Map<String,dynamic> body = {
      "date":date,
      "hour":widget.selectedTime.hour.toString()
  };
    var response =  await apiService.register(body);

    if(response.message != ''){
      showSnackBar(context , response.message);
      Navigator.pop(context);
    }
      isLoading = false;
    setState(() {
    });
  }

  listOfSpots (bool isActual){
    bcd.clear();
    if(isActual){
      predictedCount = null;
      countData.visitCounts.forEach((key, value) {
        bcd.add(BarChartGroupData(
          x: int.parse(key),
          barRods: [BarChartRodData(

              borderRadius: BorderRadius.zero,
              width: 10, color: Colors.blue,
              toY: double.parse(value.toString()))],
        ))   ;
      });
    }else{
      predictedCount!.data.forEach((key, value) {
        bcd.add(BarChartGroupData(
          barsSpace: 200,
          x: int.parse(key),
          barRods: [BarChartRodData(
              borderRadius: BorderRadius.zero,
              width: 10, color: Colors.blue, toY: double.parse(value.toString()))],
        ))   ;
      });
    }

  }


  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5), // Adjust the duration as needed
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget defaultGetTitle(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        softWrap: true,
        style: Theme.of(context).textTheme.bodySmall,
        meta.formattedValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back_ios_new,color: Colors.grey,)),
      centerTitle: true,
            title: Text('CROWD PREDICTION',style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),),
      ),
      body:  isLoading ?   Loader(loading: isLoading): Column(
        children: [
         Container(
           color: Colors.grey.shade800
           ,
           margin: EdgeInsets.symmetric(horizontal: 10.h),
           child:   Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
              
              Column(
               children: [
                 Text('Your Time & Date',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white ,fontWeight: FontWeight.w700),),
                 Text(userSelectedDate,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white ,fontWeight: FontWeight.w700),),
                 Text(userSelectedTime,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white ,fontWeight: FontWeight.w700),),
               ],
             ),

              Container(
                margin:  EdgeInsets.symmetric(horizontal: 7.w,vertical: 20.h),
                height: 80.h,
                width: 100.w,
                child:  CircleAvatar(
                  radius: 30.r,
                  backgroundImage:
                  const NetworkImage('https://images.pexels.com/photos/1299086/pexels-photo-1299086.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
                  backgroundColor: Colors.transparent,
                )
              ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Number of User',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white ,fontWeight: FontWeight.w700),),
            Text(predictedCount == null ? actualNumberOfUser() : predictedNumberOfUser(),style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white ,fontWeight: FontWeight.w700),maxLines: 3,),
            Text('at',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white ,fontWeight: FontWeight.w700),),
            Text( '${widget.selectedTime.hour} ${isPmOrAm()}',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white ,fontWeight: FontWeight.w700),maxLines: 3),
          ],
        ),



             ],
           )
           ,
         )


,
           Container(
             margin: const EdgeInsets.symmetric(vertical: 10),
             child:  Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 Text('DAY ANALYTICS',style:  Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),),
                 DropdownMenu(
                   onSelected: (index){
                     setState(() {

                     });
                     selectedIndex = index!;
                     if(index == 1){
                       getPredictedCrowed();
                     }else{
                       getArticles();
                     }
                   },
                     initialSelection: selectedIndex,
                     menuStyle: MenuStyle(
                         shape:  MaterialStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(20) ))
                     ),
                     hintText: 'select',
                     inputDecorationTheme: InputDecorationTheme(
                         contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                         constraints: BoxConstraints(
                             maxWidth: 250.w,
                             minWidth: 100.w,
                             maxHeight: 100.h
                         ),
                         enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(30.r))
                     ),
                     dropdownMenuEntries:  List.generate(options.length, (index) {
                       return  DropdownMenuEntry(
                         label: options[index], value: index,

                       );
                     })
                 ),

               ],
             ),
           ),
        Container(
          margin:  EdgeInsets.symmetric(vertical: 10.h),
          height: 300.h,
          width: MediaQuery.sizeOf(context).width,
          child:   CustomScrollView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              slivers: <Widget>[
                SliverToBoxAdapter(child:  SizedBox(
                  width: selectedIndex == 0 ? MediaQuery.sizeOf(context).width :600.w,
                  child:  BarChart(
                    BarChartData(
                        titlesData: FlTitlesData(
                          rightTitles: AxisTitles(
                            drawBelowEverything: true,
                            axisNameWidget: Text('No of Person',style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700
                            )),
                            axisNameSize: 20,
                          ),

                          topTitles: AxisTitles(
                            drawBelowEverything: true,
                            axisNameWidget: Text('No of hours',style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700
                            )),
                            axisNameSize: 20,
                          ),

                          bottomTitles:  AxisTitles(
                              sideTitles: SideTitles(reservedSize: 30,
                                  getTitlesWidget: defaultGetTitle,
                                  showTitles: true)),

                        ),
                        // alignment: BarChartAlignment.spaceEvenly,
                        borderData: FlBorderData(
                          border: Border(
                            left: BorderSide(width: 1.w),
                            bottom: BorderSide(width: 1.w),
                          ),
                        ),
                        //  groupsSpace: 20,
                        barGroups: bcd
                    ),
                  ),
                )), //Your graph widget
                //Reformat your list into a sliver list.
              ]
          ),
        )
       ,

          Container(
  margin: EdgeInsets.symmetric(
    horizontal: 20.w,vertical: 10.h
  ),
  child:
  Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
          onPressed: (){
            setState(() {

            });
            register();
          },
          child: Text('confirm',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),))
    ],
  ),
)
        ],
      ),
    );
  }
}
