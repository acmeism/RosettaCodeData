#include <stdio.h>
#include <math.h>

int main() {
    int i, p, low, high, pow = 1, osc;
    int oddSq[120];
    for (p = 0; p < 5; ++p) {
        low = (int)ceil(sqrt((double)pow));
        if (!(low%2)) ++low;
        pow *= 10;
        high = (int)sqrt((double)pow);
        for (i = low, osc = 0; i <= high; i += 2) {
            oddSq[osc++] = i * i;
        }
        printf("%d odd square from %d to %d:\n", osc, pow/10, pow);
        for (i = 0; i < osc; ++i) {
            printf("%d ", oddSq[i]);
            if (!((i+1)%10)) printf("\n");
        }
        printf("\n\n");
    }
    return 0;
}
