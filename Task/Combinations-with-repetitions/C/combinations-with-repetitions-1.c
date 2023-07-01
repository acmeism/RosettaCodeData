#include <stdio.h>

const char *donuts[] = {"iced", "jam", "plain",
                        "something completely different"};
int pos[] = {0, 0, 0, 0};

void printDonuts(int k) {
  for (size_t i = 1; i < k + 1; i += 1) // offset: i:1..N, N=k+1
    printf("%s\t", donuts[pos[i]]);     // str:0..N-1
  printf("\n");
}

// idea: custom number system with 2s complement like 0b10...0==MIN stop case
void combination_with_repetiton(int n, int k) {
  while (1) {
    for (int i = k; i > 0; i -= 1) {
      if (pos[i] > n - 1) // if number spilled over: xx0(n-1)xx
      {
        pos[i - 1] += 1; // set xx1(n-1)xx
        for (int j = i; j <= k; j += 1)
          pos[j] = pos[j - 1]; // set xx11..1
      }
    }
    if (pos[0] > 0) // stop condition: 1xxxx
      break;
    printDonuts(k);
    pos[k] += 1; // xxxxN -> xxxxN+1
  }
}

int main() {
  combination_with_repetiton(3, 2);
  return 0;
}
