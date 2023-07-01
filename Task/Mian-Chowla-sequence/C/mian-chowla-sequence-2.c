#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

// helper function for indicating memory used.
void approx(char* buf, double count)
{
    const char* suffixes[] = { "Bytes", "KiB", "MiB" };
    uint s = 0;
    while (count >= 1024 && s < 3) { s++; count /= 1024; }
    if (count - (double)((int)count) == 0.0)
        sprintf(buf, "%d %s", (int)count, suffixes[s]);
    else
        sprintf(buf, "%.1f %s", count, suffixes[s]);
}

int main() {
    int i, j, k, c = 0, n = 100, nn = 110;
    int* mc = (int*) malloc((n) * sizeof(int));
    bool* isSum = (bool*) calloc(nn, sizeof(bool));
    char em[] = "unable to increase isSum array to %ld.";
    if (n > 100)  printf("Computing terms 1 to %d...\n", n);
    clock_t st = clock();
    for (i = 1; c < n; i++) {
        mc[c] = i;
        if (i + i > nn) {
            bool* newIs = (bool*)realloc(isSum, (nn <<= 1) * sizeof(bool));
            if (newIs == NULL) { printf(em, nn); return -1; }
            isSum = newIs;
            for (j = (nn >> 1); j < nn; j++) isSum[j] = false;
        }
        bool isUnique = true;
        for (j = 0; (j < c) && isUnique; j++) isUnique = !isSum[i + mc[j]];
        if (isUnique) {
            for (k = 1; k <= c; k++) isSum[i + mc[k]] = true;
            c++;
        }
    }
    double et = 1e3 * ((double)(clock() - st)) / CLOCKS_PER_SEC;
    free(isSum);
    printf("The first 30 terms of the Mian-Chowla sequence are:\n");
    for (i = 0; i < 30; i++) printf("%d ", mc[i]);
    printf("\n\nTerms 91 to 100 of the Mian-Chowla sequence are:\n");
    for (i = 90; i < 100; i++) printf("%d ", mc[i]);
    if (c > 100) printf("\nTerm %d is: %d" ,c , mc[c - 1]);
    free(mc);
    char buf[100]; approx(buf, nn * sizeof(bool));
    printf("\n\nComputation time was %6.3f ms.  Allocation was %s.", et, buf);
}
