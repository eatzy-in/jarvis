class FetchNewOrderResponse {
  Map<OrderStatus, List<OrderMetaData>> orderStatusListHashMap;

  FetchNewOrderResponse.name(this.orderStatusListHashMap);

  factory FetchNewOrderResponse.fromJson(Map<dynamic, dynamic> json) {
    return FetchNewOrderResponse.name(parseMap(json["orderStatusListHashMap"]));
  }

  static parseMap(Map<String, dynamic> json) {
    Map<OrderStatus, List<OrderMetaData>> output = Map();
    json.forEach((key, value) => {
          output[OrderStatusExt.parse(key)] =
              (value as List).map((e) => OrderMetaData.fromJson(e)).toList()
        });
    return output;
  }
}

enum OrderStatus {
  ORDER_CREATED,
  ORDER_RECEIVED,
  ORDER_PROCESS,
  ORDER_DELIVERED,
  ORDER_FAILED,
  ORDER_PENDING,
  ORDER_CANCELLED,
  ORDER_ACCEPTED,
  ORDER_PREPARING,
  ORDER_COMPLETED
}

extension OrderStatusExt on OrderStatus {
  static OrderStatus parse(String value) {
    switch (value) {
      case "ORDER_CREATED":
        return OrderStatus.ORDER_CREATED;
      case "ORDER_PENDING":
        return OrderStatus.ORDER_PENDING;
      case "ORDER_ACCEPTED":
        return OrderStatus.ORDER_ACCEPTED;
      case "ORDER_PREPARING":
        return OrderStatus.ORDER_PREPARING;
      case "ORDER_COMPLETED":
        return OrderStatus.ORDER_COMPLETED;
      case "ORDER_RECEIVED":
        return OrderStatus.ORDER_RECEIVED;
    }
    return OrderStatus.ORDER_CREATED;
  }

  static String parseOrder(OrderStatus value) {
    String result = "";
    if (value == OrderStatus.ORDER_CREATED) {
      result = "Order Created";
    } else if(value == OrderStatus.ORDER_PENDING){
      result = " Order Pending";
    }
    else if (value == OrderStatus.ORDER_ACCEPTED) {
      result = "Order Accepted";
    } else if (value == OrderStatus.ORDER_PREPARING) {
      result = "Order Preparing}";
    } else if (value == OrderStatus.ORDER_COMPLETED) {
      result = "Order Completed";
    } else if (value == OrderStatus.ORDER_RECEIVED) {
      result = "Order Received";
    }
    return result;
  }
}

class OrderMetaData {
  String orderID;
  String userId;
  String outletID;
  String outletName;
  String outletImageLogo;
  String orderAmount;
  String orderTime;
  List<OrderedMenuItem> orderedMenuItemList;
  OrderStatus orderStatus;
  UserMetaData userMetaData;

  OrderMetaData.name(
      this.orderID,
      this.userId,
      this.outletID,
      this.outletName,
      this.outletImageLogo,
      this.orderAmount,
      this.orderTime,
      this.orderedMenuItemList,
      this.orderStatus,
      this.userMetaData);

  factory OrderMetaData.fromJson(Map<String, dynamic> json) {
    return OrderMetaData.name(
        json['orderID'],
        json['userId'],
        parseString(json['outletID']),
        parseString(json['outletName']),
        parseString(json['outletImageLogo']),
        json['orderAmount'],
        json['orderTime'],
        parseList(json['orderedMenuItemList']),
        OrderStatusExt.parse(json['orderStatus']),
        UserMetaData.fromJson(json['userMetaData'])
    );
  }

  static parseString(dynamic json){
    return json == null ? "": json as String;
  }

  static parseList(List<dynamic> json) {
    List<OrderedMenuItem> orderMenuList = [];
    json.forEach((element) {
      orderMenuList.add(OrderedMenuItem.fromJson(element));
    });
    return orderMenuList;
  }
}

class UserMetaData {
  String userID;
  String userName;
  String userMobile;
  String userEmail;

  UserMetaData.name(this.userID, this.userName, this.userMobile, this.userEmail);
  factory UserMetaData.fromJson(Map<String, dynamic> json) {
    return UserMetaData.name(
        json['userID'], json['userName'], json['userMobile'], json['userEmail']);
  }
}

class OrderedMenuItem {
  String menuID;
  String menuName;
  String price;
  int quantity;
  int servingType;


  OrderedMenuItem.name(this.menuID, this.menuName,
      this.price, this.quantity, this.servingType);

  factory OrderedMenuItem.fromJson(Map<String, dynamic> json) {
    return OrderedMenuItem.name(
        json['menuID'], json['menuName'],
        json['price'], json['quantity'],
      json['servingType']
    );
  }
}

enum ServingType {
  PACKAGING, DINE_IN, TO_DELIVER
}

extension ServingTypeExt on ServingType {
  static ServingType parse(String value) {
    switch (value) {
      case "PACKAGING":
        return ServingType.PACKAGING;
      case "DINE_IN":
        return ServingType.DINE_IN;
      case "TO_DELIVER":
        return ServingType.TO_DELIVER;
    }
    return ServingType.DINE_IN;
  }
}

