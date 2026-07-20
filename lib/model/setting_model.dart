class SettingModel {
  final String id;
  final String name;
  final String value;
  final List<String> currencyList;

  SettingModel({
    required this.id,
    required this.name,
    required this.value,
    this.currencyList = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SettingModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'currency_list': currencyList,
    };
  }

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      id: json['id'],
      name: json['name'],
      value: json['value'],
      currencyList: List<String>.from(json['currency_list'] ?? []),
    );
  }
}
