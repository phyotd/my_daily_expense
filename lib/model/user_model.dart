class UserModel {
  final String id;
  final String name;
  final String? email;
  final double walletBalance;
  final double expenseBalance;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.walletBalance = 0.0,
    this.expenseBalance = 0.0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': name,
      'email': email,
      'wallet_balance': walletBalance,
      'expense_balance': expenseBalance,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? "",
      name: json['user_name'] ?? "",
      email: json['email'] ?? "",
      walletBalance: json['wallet_balance']?.toDouble() ?? 0.0,
      expenseBalance: json['expense_balance']?.toDouble() ?? 0.0,
    );
  }
}
