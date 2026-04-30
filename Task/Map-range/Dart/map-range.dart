double mapRange(int s, int a1, int a2, int b1, int b2) {
  return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
}

void main() {
  for (int i = 0; i <= 10; i++) {
    double r = mapRange(i, 0, 10, -1, 0);
    print("${i.toString().padLeft(2)} maps to ${r.toStringAsFixed(1)}");
  }
}
