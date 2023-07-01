sumOfSquares(list) {
  var sum=0;
  list.forEach((var n) { sum+=(n*n); });
  return sum;
}

main() {
  print(sumOfSquares([]));
  print(sumOfSquares([1,2,3]));
  print(sumOfSquares([10]));
}
