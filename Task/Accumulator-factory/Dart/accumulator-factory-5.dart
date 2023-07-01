void main() {
  var x = makeAccumulator(1);
  print(x(5).runtimeType); // int
  print(x(2.3).runtimeType); // double
  print(x(4).runtimeType); // double
}
