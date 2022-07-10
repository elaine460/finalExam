class User {
  String? id;
  String? email;
  String? password;
  String? name;
  String? phone;
  String? address;
  String? cart;

  User(
      {this.id,
      this.email,
      this.password,
      this.name,
      this.phone,
      this.address, 
      this.cart});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    cart = json['cart'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['cart'] = cart.toString();
    return data;
  }
}

