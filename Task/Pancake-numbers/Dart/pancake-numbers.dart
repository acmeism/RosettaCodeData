void main() {
  for (int i = 0; i <= 3; i++) {
    for (int j = 1; j <= 5; j++) {
      int n = (i * 5) + j;
      print("p(${n.toString().padLeft(2, ' ')}) = ${pancake(n).toString().padLeft(2, ' ')}");
    }
  }
}

int pancake(int n) {
  int gap = 2;
  int sum = 2;
  int adj = -1;
  while (sum < n) {
    adj++;
    gap = (gap * 2) - 1;
    sum += gap;
  }
  return n + adj;
}
