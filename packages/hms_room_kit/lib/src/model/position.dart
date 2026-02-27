class Position {
  double? top;
  double? right;
  double? bottom;
  double? left;

  Position(
      {required this.top,
      required this.right,
      required this.bottom,
      required this.left});

  Position.all(double value)
      : top = value,
        right = value,
        bottom = value,
        left = value;
  Position.symmetric({double vertical = 0.0, double horizontal = 0.0})
      : top = vertical,
        right = horizontal,
        bottom = vertical,
        left = horizontal;
  Position.only(
      {this.top = 0.0, this.right = 0.0, this.bottom = 0.0, this.left = 0.0});
}
