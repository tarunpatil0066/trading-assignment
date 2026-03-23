class Stock {
  final String symbol;
  final String description;
  final double price;
  final double changeValue;
  final double changePercentage;
  final bool isPositive;

  Stock({
    required this.symbol,
    required this.description,
    required this.price,
    required this.changeValue,
    required this.changePercentage,
    required this.isPositive,
  });
}