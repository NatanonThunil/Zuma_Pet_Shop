class Users {
  String uid;
  final String email;
  final int balance;
  final int point;

  Users({
    required this.uid,
    required this.email,
    required this.balance,
    required this.point,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'productName': email,
        'shopName': balance,
        'price': point,
      };

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uid: json['uid'],
      email: json['email'],
      balance: json['balance'],
      point: json['point'],
    );
  }
}
