class ExpenseItem {
  String name;
  String date;
  int amount;
  String type;

  ExpenseItem({
    required this.name,
    required this.date,
    required this.amount,
    required this.type,
  });

  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      name: json['name'],
      date: json['date'],
      amount: json['amount'],
      type: json['type'],
    );
  }
}
