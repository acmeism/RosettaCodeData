#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int compare(const void *a, const void *b) {
    int ia = *(int*)a;
    int ib = *(int*)b;
    return (ia>ib) - (ia<ib);
}

int main() {
    int pows[16];
    int a, b, i=0;

    for (a=2; a<=5; a++)
        for (b=2; b<=5; b++)
            pows[i++] = pow(a, b);

    qsort(pows, 16, sizeof(int), compare);

    for (i=0; i<16; i++)
        if (i==0 || pows[i] != pows[i-1])
            printf("%d ", pows[i]);

    printf("\n");
    return 0;
}
