import 'dart:async';
import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:seller_central_eatzy/model/fetch_new_order_response.dart';
import 'package:http/http.dart' as http;
import 'package:seller_central_eatzy/service/api_handler.dart';

class OrderPage extends StatefulWidget {
  String outletID;

  OrderPage.name(this.outletID);

  @override
  OrderPageState createState() => OrderPageState();
}

class OrderPageState extends State<OrderPage> {
  late FetchNewOrderResponse fetchNewOrder;
  late Timer timer;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(Duration(seconds: 50), (Timer t) => callNewOrderAPI());
  }

  Future<FetchNewOrderResponse> callNewOrderAPI() async {
    Map<dynamic, dynamic> result = await APIHandler().callAPI(
        API.API_NEW_ORDERS, <String, String>{"outletID": widget.outletID});
    if (result.isNotEmpty) {
      // If the server did return a 201 CREATED response,
      setState(() {
        fetchNewOrder = FetchNewOrderResponse.fromJson(result);
        if (getList(OrderStatus.ORDER_COMPLETED).isNotEmpty) {
          isCompleted = true;
        }
      });

      return fetchNewOrder;
    } else {
      throw Exception('try again, failed to fetch cart' + result.toString());
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<FetchNewOrderResponse>(
            future: callNewOrderAPI(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child:Column(
                      mainAxisSize: MainAxisSize.min,
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

  List<Widget> getMyWidget(BuildContext context) {
    return [
      SizedBox(
        height: 50,
      ),
      buildOrderHeader("New Orders", Icons.new_releases_sharp),
       Divider(),
       buildNewOrder(getList(OrderStatus.ORDER_PENDING)),
       Divider(),
       buildOrderHeader("Processing Orders", Icons.run_circle_outlined),
       Divider(),
       buildAcceptedOrder(getList(OrderStatus.ORDER_ACCEPTED)),
       Divider(),
       buildOrderHeader("Completed Orders", Icons.done) ,
       Divider(),
       buildCompletedOrder(getList(OrderStatus.ORDER_COMPLETED))
    ];
  }

  List<OrderMetaData> getList(OrderStatus status) {
    if (fetchNewOrder.orderStatusListHashMap.containsKey(status)) {
      return fetchNewOrder.orderStatusListHashMap[status]!;
    } else {
      return [];
    }
  }

  Widget buildOrderHeader(String text, IconData iconData) {
    return ListTile(
      textColor: Colors.teal,
      title: Text(text),
      leading: Icon(iconData),
    );
  }

  Widget defaultOrderInfo(String text) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Card(child: ListTile(title: Text("Currently, No New Orders"))),
    );
  }

  Widget buildNewOrder(List<dynamic> newOrders) {
    if (newOrders.length == 0)
      return defaultOrderInfo("Nothing .....");
    return Card(
        child: Column(children: [
      Container(
        color: Colors.teal,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        height: MediaQuery.of(context).size.height * 0.20,
        child: ListView.builder(
            itemCount: newOrders.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Container(
                  height: 50,
                  width: 100,
                  child: buildOrderDetailWidget(newOrders[index]),
                ),
                onTap: () async {
                  await DialogBackground(
                      dialog: AlertDialog(
                          title: Text("Order Details"),
                          content: Container(
                              height: 500.0,
                              // Change as per your requirement
                              width: 500.0,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: newOrders[index]
                                      .orderedMenuItemList
                                      .length,
                                  itemBuilder: (context, i) {
                                    return buildOrderMenuItemWidgetList(
                                        newOrders[index]
                                            .orderedMenuItemList[i]);
                                  })),
                          actions: <Widget>[
                        FlatButton(
                            child: Text("Accept"),
                            onPressed: () {
                              updateStatusOfOrder(
                                      (newOrders[index] as OrderMetaData)
                                          .orderID,
                                      OrderStatus.ORDER_ACCEPTED)
                                  .then((value) => callNewOrderAPI());
                              Navigator.of(context).pop();
                            }),
                        FlatButton(
                            child: Text("Reject"),
                            onPressed: () {
                              updateStatusOfOrder(
                                      (newOrders[index] as OrderMetaData)
                                          .orderID,
                                      OrderStatus.ORDER_FAILED)
                                  .then((value) => callNewOrderAPI());
                              Navigator.of(context).pop();
                            })
                      ])).show(context);
                },
              );
            }),
      )
    ]));
  }

  Widget buildCompletedOrder(List<dynamic> newOrders) {
    if (newOrders.length == 0)
      return defaultOrderInfo("Nothing .....");
    return Card(
        child: Column(children: [
          Container(
            color: Colors.teal,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            height: MediaQuery.of(context).size.height * 0.20,
            child: ListView.builder(
                itemCount: newOrders.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      height: 50,
                      width: 100,
                      child: buildOrderDetailWidget(newOrders[index]),
                    ),
                    onTap: () async {
                      await DialogBackground(
                          dialog: AlertDialog(
                              title: Text("Order Details"),
                              content: Container(
                                  height: 500.0,
                                  // Change as per your requirement
                                  width: 500.0,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: newOrders[index]
                                          .orderedMenuItemList
                                          .length,
                                      itemBuilder: (context, i) {
                                        return buildOrderMenuItemWidgetList(
                                            newOrders[index]
                                                .orderedMenuItemList[i]);
                                      })),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text("Accept"),
                                    onPressed: () {
                                      updateStatusOfOrder(
                                          (newOrders[index] as OrderMetaData)
                                              .orderID,
                                          OrderStatus.ORDER_RECEIVED)
                                          .then((value) => callNewOrderAPI());
                                      Navigator.of(context).pop();
                                    }),
                                FlatButton(
                                    child: Text("Reject"),
                                    onPressed: () {
                                      updateStatusOfOrder(
                                          (newOrders[index] as OrderMetaData)
                                              .orderID,
                                          OrderStatus.ORDER_FAILED)
                                          .then((value) => callNewOrderAPI());
                                      Navigator.of(context).pop();
                                    })
                              ])).show(context);
                    },
                  );
                }),
          )
        ]));
  }

  Widget buildAcceptedOrder(List<dynamic> orders) {
    if (orders.length == 0)
      return defaultOrderInfo("Currently, No Processing Orders");
    return Container(
      color: Colors.teal,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: MediaQuery.of(context).size.height * 0.40,
      child: GridView.count(

          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 3,

          // Generate 100 widgets that display their index in the List.
          children: List.generate(orders.length, (index) {
            return GestureDetector(
              child: Container(
                height: 50,
                width: 50,
                child: buildProcessingOrderDetailWidget(orders[index]),
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
                                itemCount:
                                    orders[index].orderedMenuItemList.length,
                                itemBuilder: (context, i) {
                                  return buildOrderMenuItemWidgetList(
                                      orders[index].orderedMenuItemList[i]);
                                })),
                        actions: <Widget>[
                      FlatButton(
                          child: Text("Completed"),
                          onPressed: () {
                            updateStatusOfOrder(
                                    (orders[index] as OrderMetaData).orderID,
                                    OrderStatus.ORDER_COMPLETED)
                                .then((value) => callNewOrderAPI());
                            Navigator.of(context).pop();
                          }),
                      FlatButton(
                          child: Text("Add delay 5 min"),
                          onPressed: () {
                            updateStatusOfOrder(
                                    (orders[index] as OrderMetaData).orderID,
                                    (orders[index] as OrderMetaData)
                                        .orderStatus)
                                .then((value) => callNewOrderAPI());
                            Navigator.of(context).pop();
                          })
                    ])).show(context);
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
      child: Container(padding: EdgeInsets.all(5), child: Column(children: [
        ListTile(
          title: Text(orderedMenuItem.menuName, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          leading: Icon(Icons.emoji_food_beverage_sharp),
        ),
        Divider(),
        Row(children: [Text("Quantity: ", style: TextStyle(color: Colors.teal),), Spacer(),Text(orderedMenuItem.quantity.toString())]),
        Row(children: [Text("Type: ", style: TextStyle(color: Colors.teal)), Spacer(),Text(parseNameFromServingType(orderedMenuItem.servingType), style: TextStyle(color: Colors.red),)]),
      ])),
    );
  }

  String parseNameFromServingType(int servingType){
    switch(servingType){
      case 1:
        return "Parcel";
      case 2:
        return "Dine-In";
    }
    return "Dine-In";
  }

  buildOrderDetailWidget(OrderMetaData orderMetaData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 20,
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(children: [
            Text(
              "Order ID",
              style: TextStyle(fontSize: 12),
            ),
            Spacer(),
            Text(orderMetaData.orderID.substring(0, 5),
                style: TextStyle(fontSize: 12))
          ]),
          Text("5 min ago ", maxLines: 2, style: TextStyle(fontSize: 10)),
          Divider(),
          Text(orderMetaData.userMetaData.userName,
              maxLines: 2, textAlign: TextAlign.center),
          Divider(),
          Row(children: [
            Text(
              "Amount",
              style: TextStyle(fontSize: 10),
            ),
            Spacer(),
            Text("Rs 525", style: TextStyle(fontSize: 10))
          ])
        ],
      ),
    );
  }

  buildProcessingOrderDetailWidget(OrderMetaData orderMetaData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 20,
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Divider(),
          Row(children: [
            Text(
              "Processing From:",
              style: TextStyle(fontSize: 8),
            ),
            Spacer(),
            Text(" 5 min ago", style: TextStyle(fontSize: 8))
          ]),
          Divider(),
          Text(orderMetaData.orderID.substring(0, 5),
              maxLines: 2, textAlign: TextAlign.center),
          Divider(),
          Row(children: [
            Text(
              "User:",
              style: TextStyle(fontSize: 8),
            ),
            Spacer(),
            Text(orderMetaData.userMetaData.userName,
                style: TextStyle(fontSize: 8))
          ]),
          Divider(),
        ],
      ),
    );
  }

  Widget buildOnTimeOrder(BuildContext context) {
    final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      height: MediaQuery.of(context).size.height * 0.33,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: numbers.length,
          itemBuilder: (context, index) {
            return Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: GestureDetector(
                  child: Card(
                    color: Colors.blue,
                    child: Container(
                      child: Center(
                          child: Text(
                        numbers[index].toString(),
                        style: TextStyle(color: Colors.white, fontSize: 36.0),
                      )),
                    ),
                  ),
                  onTap: () async {
                    await DialogBackground(
                        dialog: AlertDialog(
                            title: Text("Alert Dialog"),
                            content: Container(
                                height: 300.0, // Change as per your requirement
                                width: 300.0,
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          title: Text("chola Bhatura"),
                                          subtitle: Text("Quantity: 2"),
                                          leading:
                                              Image.asset("assets/snapzy.png"),
                                          trailing: ElevatedButton(
                                              onPressed: () {},
                                              child: Text(
                                                "Done",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.teal,
                                                // background
                                                onPrimary:
                                                    Colors.white, // foreground
                                              )),
                                        ),
                                      );
                                    })),
                            actions: <Widget>[
                          FlatButton(
                              child: Text("Mark Done"), onPressed: () {}),
                          FlatButton(child: Text("Add Delay"), onPressed: () {})
                        ])).show(context);
                  },
                ));
          }),
    );
  }

  Widget buildDelayedOrder(BuildContext context) {
    final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      height: MediaQuery.of(context).size.height * 0.33,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: numbers.length,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: GestureDetector(
                child: Card(
                  color: Colors.blue,
                  child: Container(
                    child: Center(
                        child: Text(
                      numbers[index].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 36.0),
                    )),
                  ),
                ),
                onTap: () async {
                  await DialogBackground(
                      dialog: AlertDialog(
                          title: Text("Alert Dialog"),
                          content: Container(
                              height: 300.0, // Change as per your requirement
                              width: 300.0,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        title: Text("chola Bhatura"),
                                        subtitle: Text("Quantity: 2"),
                                        leading:
                                            Image.asset("assets/snapzy.png"),
                                        trailing: ElevatedButton(
                                            onPressed: () {},
                                            child: Text(
                                              "Done",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.teal,
                                              // background
                                              onPrimary:
                                                  Colors.white, // foreground
                                            )),
                                      ),
                                    );
                                  })),
                          actions: <Widget>[
                        FlatButton(child: Text("Mark Done"), onPressed: () {}),
                        FlatButton(child: Text("Add Delay"), onPressed: () {})
                      ])).show(context);
                },
              ),
            );
          }),
    );
  }
}

//Todo remove
class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  final Image img;

  const CustomDialogBox(
      {Key? key,
      required this.title,
      required this.descriptions,
      required this.text,
      required this.img})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.text,
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset("assets/model.jpeg")),
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}
