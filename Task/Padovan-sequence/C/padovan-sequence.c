#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

/* Generate (and memoize) the Padovan sequence using
 * the recurrence relationship */
int pRec(int n) {
    static int *memo = NULL;
    static size_t curSize = 0;

    /* grow memoization array when necessary and fill with zeroes */
    if (curSize <= (size_t) n) {
        size_t lastSize = curSize;
        while (curSize <= (size_t) n) curSize += 1024 * sizeof(int);
        memo = realloc(memo, curSize * sizeof(int));
        memset(memo + lastSize, 0, (curSize - lastSize) * sizeof(int));
    }

    /* if we don't have the value for N yet, calculate it */
    if (memo[n] == 0) {
        if (n<=2) memo[n] = 1;
        else memo[n] = pRec(n-2) + pRec(n-3);
    }

    return memo[n];
}

/* Calculate the Nth value of the Padovan sequence
 * using the floor function */
int pFloor(int n) {
    long double p = 1.324717957244746025960908854;
    long double s = 1.0453567932525329623;
    return powl(p, n-1)/s + 0.5;
}

/* Given the previous value for the L-system, generate the
 * next value */
void nextLSystem(const char *prev, char *buf) {
    while (*prev) {
        switch (*prev++) {
            case 'A': *buf++ = 'B'; break;
            case 'B': *buf++ = 'C'; break;
            case 'C': *buf++ = 'A'; *buf++ = 'B'; break;
        }
    }
    *buf = '\0';
}

int main() {
    // 8192 is enough up to P_33.
    #define BUFSZ 8192
    char buf1[BUFSZ], buf2[BUFSZ];
    int i;

    /* Print P_0..P_19 */
    printf("P_0 .. P_19: ");
    for (i=0; i<20; i++) printf("%d ", pRec(i));
    printf("\n");

    /* Check that functions match up to P_63 */
    printf("The floor- and recurrence-based functions ");
    for (i=0; i<64; i++) {
        if (pRec(i) != pFloor(i)) {
            printf("do not match at %d: %d != %d.\n",
                i, pRec(i), pFloor(i));
            break;
        }
    }
    if (i == 64) {
        printf("match from P_0 to P_63.\n");
    }

    /* Show first 10 L-system strings */
    printf("\nThe first 10 L-system strings are:\n");
    for (strcpy(buf1, "A"), i=0; i<10; i++) {
        printf("%s\n", buf1);
        strcpy(buf2, buf1);
        nextLSystem(buf2, buf1);
    }

    /* Check lengths of strings against pFloor up to P_31 */
    printf("\nThe floor- and L-system-based functions ");
    for (strcpy(buf1, "A"), i=0; i<32; i++) {
        if ((int)strlen(buf1) != pFloor(i)) {
            printf("do not match at %d: %d != %d\n",
                i, (int)strlen(buf1), pFloor(i));
            break;
        }
        strcpy(buf2, buf1);
        nextLSystem(buf2, buf1);
    }
    if (i == 32) {
        printf("match from P_0 to P_31.\n");
    }

    return 0;
}
