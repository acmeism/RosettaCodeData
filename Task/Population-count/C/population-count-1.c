#include <stdio.h>

int main() {
  {
    unsigned long long n = 1;
    for (int i = 0; i < 30; i++) {
      // __builtin_popcount() for unsigned int
      // __builtin_popcountl() for unsigned long
      // __builtin_popcountll() for unsigned long long
      printf("%d ", __builtin_popcountll(n));
      n *= 3;
    }
    printf("\n");
  }

  int od[30];
  int ne = 0, no = 0;
  printf("evil  : ");
  for (int n = 0; ne+no < 60; n++) {
    if ((__builtin_popcount(n) & 1) == 0) {
      if (ne < 30) {
	printf("%d ", n);
	ne++;
      }
    } else {
      if (no < 30) {
	od[no++] = n;
      }
    }
  }
  printf("\n");
  printf("odious: ");
  for (int i = 0; i < 30; i++) {
    printf("%d ", od[i]);
  }
  printf("\n");

  return 0;
}
