#include <stdio.h>
#include <stdlib.h>

int compare(const void *a, const void *b) {
    int aa = *(const int *)a;
    int bb = *(const int *)b;
    if (aa < bb) return -1;
    if (aa > bb) return 1;
    return 0;
}

int main() {
    int a[] = {6, 81, 243, 14, 25, 49, 123, 69, 11};
    int isize = sizeof(int);
    int asize = sizeof(a) / isize;
    int i, sum;
    while (asize > 1) {
        qsort(a, asize, isize, compare);
        printf("Sorted list: ");
        for (i = 0; i < asize; ++i) printf("%d ", a[i]);
        printf("\n");
        sum = a[0] + a[1];
        printf("Two smallest: %d + %d = %d\n", a[0], a[1], sum);
        for (i = 2; i < asize; ++i) a[i-2] = a[i];
        a[asize - 2] = sum;
        asize--;
    }
    printf("Last item is %d.\n", a[0]);
    return 0;
}
