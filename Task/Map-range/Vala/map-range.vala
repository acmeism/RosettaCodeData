double map_range(double s, int a1, int a2, int b1, int b2) {
  return b1+(s-a1)*(b2-b1)/(a2-a1);
}

void main() {
  for (int s = 0; s < 11; s++){
    print("%2d maps to %5.2f\n", s, map_range(s, 0, 10, -1, 0));
  }
}
