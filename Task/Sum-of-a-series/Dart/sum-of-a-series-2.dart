f(double x) {
  if (x == 0)
    return x;
  else
    return (1.0 / (x * x)) + f(x - 1.0);
}

main() {
  print(f(1000));
}
