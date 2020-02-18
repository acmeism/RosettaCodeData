const char a1[] = {'a','b','c'};
const char a2[] = {'A','B','C'};
const int a3[] = {1, 2, 3};

void main() {
  for (int i = 0; i < 3; i++)
    stdout.printf("%c%c%i\n", a1[i], a2[i], a3[i]);
}
