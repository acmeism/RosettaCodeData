void leoN(int cnt, {int l0 = 1, int l1 = 1, int add = 1}) {
  int t;
  for (int i = 0; i < cnt; i++) {
    print('$l0 ');
    t = l0 + l1 + add;
    l0 = l1;
    l1 = t;
  }
}

void main() {
  print('Leonardo Numbers: ');
  leoN(25);
  print('\nFibonacci Numbers: ');
  leoN(25, l0: 0, l1: 1, add: 0);
}
