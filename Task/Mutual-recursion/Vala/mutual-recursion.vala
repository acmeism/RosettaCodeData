int F(int n) {
  if (n == 0) return 1;
  return n - M(F(n - 1));
}

int M(int n) {
  if (n == 0) return 0;
  return n - F(M(n - 1));
}

void main() {
  print("n : ");
  for (int s = 0; s < 25; s++){
    print("%2d ", s);
  }
  print("\n------------------------------------------------------------------------------\n");
  print("F : ");
  for (int s = 0; s < 25; s++){
    print("%2d ", F(s));
  }
  print("\nM : ");
  for (int s = 0; s < 25; s++){
    print("%2d ", M(s));
  }
}
