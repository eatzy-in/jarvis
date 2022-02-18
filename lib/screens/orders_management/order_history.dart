import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:seller_central_eatzy/model/fetch_new_order_response.dart';
import 'package:seller_central_eatzy/service/api_handler.dart';

class OrderHistory extends StatefulWidget{
  String outletID;

  OrderHistory.name(this.outletID);

  @override
  OrderHistoryState createState() => OrderHistoryState();
}

class OrderHistoryState extends State<OrderHistory> {
  late FetchNewOrderResponse fetchNewOrder;

  Future<FetchNewOrderResponse> callNewOrderAPI() async {
    Map<dynamic, dynamic> result = await APIHandler().callAPI(
        API.API_NEW_ORDERS, <String, String>{"outletID": widget.outletID});
    if (result.isNotEmpty) {
      // If the server did return a 201 CREATED response,
      setState(() {
        fetchNewOrder = FetchNewOrderResponse.fromJson(result);
      });

      return fetchNewOrder;
    } else {
      throw Exception('try again, failed to fetch cart' + result.toString());
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: FutureBuilder<FetchNewOrderResponse>(
            future: callNewOrderAPI(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: getMyWidget(context),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return Center(child:  CircularProgressIndicator());
            }));
  }

  getMyWidget(BuildContext context) {
    return [
      SizedBox(height: 40,),
      buildOrderHeader("Successful Orders", Icons.run_circle_outlined),
      Divider(),
      buildSuccessfulOrder(getList(OrderStatus.ORDER_RECEIVED)),
      Divider(),
      buildOrderHeader("Failed/Cancelled Orders", Icons.run_circle_outlined),
      Divider(),
      buildFailedOrder(getList(OrderStatus.ORDER_FAILED)),
    ];
  }

  List<OrderMetaData> getList(OrderStatus status) {
    if (fetchNewOrder.orderStatusListHashMap.containsKey(status)) {
      return fetchNewOrder.orderStatusListHashMap[status]!;
    } else {
      return [];
    }
  }

  Widget defaultOrderInfo(String text) {
    return Container(
      margin: EdgeInsets.fromLTRB(20,0,20,0),
      child: Card(
          child: ListTile( title: Text(text))),
    );
  }


  buildSuccessFulOrderDetailWidget(OrderMetaData orderMetaData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 20,
      child: Column(children:[
        Divider(),
        Text("#1234", maxLines: 2,textAlign: TextAlign.center),
        Divider(),
        Row(children: [Text("Bishu", style: TextStyle(fontSize: 8),) , Spacer(), Text(orderMetaData.orderStatus.name, style: TextStyle(fontSize: 8))]),
        Divider(),
        Row(children: [Text("Total Time", style: TextStyle(fontSize: 8),) , Spacer(), Text("10min", style: TextStyle(fontSize: 8))]),
        Row(children: [Text("Amount", style: TextStyle(fontSize: 8),) , Spacer(), Text("Rs 525", style: TextStyle(fontSize: 8))]),
        Divider(),
      ],
      ),
    );
  }
  buildFailedOrderDetailWidget(OrderMetaData orderMetaData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 20,
      child: Column(children:[
        Divider(),
        Text("#1234", maxLines: 2,textAlign: TextAlign.center),
        Divider(),
        Row(children: [Text("Bishu", style: TextStyle(fontSize: 8),) , Spacer(), Text(orderMetaData.orderStatus.name, style: TextStyle(fontSize: 8))]),
        Divider(),
        Row(children: [Text("Reason", style: TextStyle(fontSize: 8),) , Spacer(), Text("Payment", style: TextStyle(fontSize: 8))]),
      ],
      ),
    );
  }

  Widget buildSuccessfulOrder(List<dynamic> orders) {
    if (orders.length == 0) return defaultOrderInfo("Currently, No Processing Orders");
    return Container(
      color: Colors.teal,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: MediaQuery.of(context).size.height * 0.40,
      child: GridView.count(

        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
          crossAxisCount: 3,


          // Generate 100 widgets that display their index in the List.
          children: List.generate(orders.length, (index){
            return GestureDetector(
              child: Container(
                height: 50,
                width: 50,
                child: buildSuccessFulOrderDetailWidget(orders[index]),
              ),
              onTap: () async {
                await DialogBackground(
                    dialog: AlertDialog(
                        title: Text("Order Details"),
                        content: Container(
                            height: 400.0, // Change as per your requirement
                            width: 400.0,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: orders[index]
                                    .orderedMenuItemList
                                    .length,
                                itemBuilder: (context, i) {
                                  return buildOrderMenuItemWidgetList(
                                      orders[index].orderedMenuItemList[i]);
                                })),
                        actions: <Widget>[
                        ])).show(context);
              },
            );
          })),
    );
  }

  Widget buildFailedOrder(List<dynamic> orders) {
    if (orders.length == 0) return defaultOrderInfo("Currently, No Processing Orders");
    return Container(
      color: Colors.teal,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: MediaQuery.of(context).size.height * 0.40,
      child: GridView.count(

        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
          crossAxisCount: 3,


          // Generate 100 widgets that display their index in the List.
          children: List.generate(orders.length, (index){
            return GestureDetector(
              child: Container(
                height: 50,
                width: 50,
                child: buildFailedOrderDetailWidget(orders[index]),
              ),
              onTap: () async {
                await DialogBackground(
                    dialog: AlertDialog(
                        title: Text("Order Details"),
                        content: Container(
                            height: 400.0, // Change as per your requirement
                            width: 400.0,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: orders[index]
                                    .orderedMenuItemList
                                    .length,
                                itemBuilder: (context, i) {
                                  return buildOrderMenuItemWidgetList(
                                      orders[index].orderedMenuItemList[i]);
                                }))));

              },
            );
          })),
    );
  }

  Future<void> updateStatusOfOrder(
      String orderId, OrderStatus orderStatus) async {
    int i = 0;
    while (i < 3) {
      Map<dynamic, dynamic> result = await APIHandler().callAPI(
          API.API_UPDATE_ORDER, <String, String>{
        "orderID": orderId,
        "orderStatus": orderStatus.name
      });
      if (result.isNotEmpty) {
        // If the server did return a 201 CREATED response,
        fetchNewOrder = FetchNewOrderResponse.fromJson(result);
        return;
      } else {
        i++;
        sleep(Duration(seconds: 3));
        if (i == 3)
          throw Exception(
              'try again, failed to fetch cart' + result.toString());
      }
    }
  }


  buildOrderMenuItemWidgetList(OrderedMenuItem orderedMenuItem) {
    return Card(
      child: ListTile(
        title: Text(orderedMenuItem.menuName),
        subtitle: Text(orderedMenuItem.quantity.toString()),
        leading: Icon(Icons.emoji_food_beverage_sharp),
      ),
    );
  }

  Widget buildOrderHeader(String text, IconData iconData) {
    return ListTile(
      textColor: Colors.teal,
      title: Text(text),
      leading: Icon(iconData),
    );
  }

}