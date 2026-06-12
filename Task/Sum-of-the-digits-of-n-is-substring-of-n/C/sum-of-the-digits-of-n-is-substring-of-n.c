#include <stdio.h>
#include <string.h>

int digitSum(int n) {
    int s = 0;
    do {s += n % 10;} while (n /= 10);
    return s;
}

int digitSumIsSubstring(int n) {
    char s_n[32], s_ds[32];
    sprintf(s_n, "%d", n);
    sprintf(s_ds, "%d", digitSum(n));
    return strstr(s_n, s_ds) != NULL;
}

int main() {
    int i;
    for (i=0; i<1000; i++)
        if (digitSumIsSubstring(i))
            printf("%d ",i);
    printf("\n");

    return 0;
}
