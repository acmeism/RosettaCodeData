void recur(uint64 v ) {
  print (@"$v\n");
  recur( v + 1);
}

void main() {
  recur(0);
}
