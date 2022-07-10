class Order {
  String? orderid;
  String? receiptid;
  String? status;//orderStatus
  String? orderDate;
  String? amount;//orderPaid

  Order(
      {this.orderid,
      this.receiptid,
      this.status,
      this.orderDate,
      this.amount});

  Order.fromJson(Map<String, dynamic> json) {
    orderid = json['orderid'];
    receiptid = json['receiptid'];
    status = json['status'];
    orderDate = json['orderdate'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderid'] = orderid;
    data['receiptid'] = receiptid;
    data['status'] = status;
    data['orderdate'] = orderDate;
    data['amount'] = amount;
    return data;
  }
}