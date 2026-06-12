#include <stdio.h>

int findMin(int a[], int asize, int *pmin) {
    int i, ix = 0;
    *pmin = a[0];
    for (i = 0; i < asize; ++i) {
        if (a[i] < *pmin) {
            ix = i;
            *pmin = a[i];
        }
    }
    return ix;
}

int main() {
    int a[] = {6, 81, 243, 14, 25, 49, 123, 69, 11};
    int isize = sizeof(int);
    int asize = sizeof(a) / isize;
    int i, j, sum, ix, min = 0, s[2];
    while (asize > 1) {
        printf("List: ");
        for (i = 0; i < asize; ++i) printf("%d ", a[i]);
        printf("\n");
        for (i = 0; i < 2; ++i) {
            ix = findMin(a, asize, &min);
            s[i] = min;
            for (j = ix+1; j < asize; ++j) a[j-1] = a[j];
            asize--;
        }
        sum = s[0] + s[1];
        printf("Two smallest: %d + %d = %d\n", s[0], s[1], sum);
        a[asize] = sum;
        asize++;
    }
    printf("Last item is %d.\n", a[0]);
    return 0;
}
