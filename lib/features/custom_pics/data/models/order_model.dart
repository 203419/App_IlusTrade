class OrderModel {
  final String theme;
  final String style;
  final String size;
  final String description;

  OrderModel({
    required this.theme,
    required this.style,
    required this.size,
    required this.description,
  });

  Map<String, String> toJson() {
    return {
      'theme': theme,
      'style': style,
      'size': size,
      'description': description,
    };
  }
}
