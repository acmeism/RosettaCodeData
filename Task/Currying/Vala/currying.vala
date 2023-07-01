delegate double Dbl_Op(double d);

Dbl_Op curried_add(double a) {
  return (b) => a + b;
}

void main() {
  print(@"$(curried_add(3.0)(4.0))\n");
  double sum2 = curried_add(2.0) (curried_add(3.0)(4.0)); //sum2 = 9
  print(@"$sum2\n");
}
