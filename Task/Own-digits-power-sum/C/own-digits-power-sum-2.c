#include <stdio.h>
#include <string.h>

#define MAX_BASE 10

typedef unsigned long long ulong;

int usedDigits[MAX_BASE];
ulong powerDgt[MAX_BASE][MAX_BASE];
ulong numbers[60];
int nCount = 0;

void initPowerDgt() {
    int i, j;
    powerDgt[0][0] = 0;
    for (i = 1; i < MAX_BASE; ++i) powerDgt[0][i] = 1;
    for (j = 1; j < MAX_BASE; ++j) {
        for (i = 0; i < MAX_BASE; ++i) {
            powerDgt[j][i] = powerDgt[j-1][i] * i;
        }
    }
}

ulong calcNum(int depth, int used[MAX_BASE]) {
    int i;
    ulong result = 0, r, n;
    if (depth < 3) return 0;
    for (i = 1; i < MAX_BASE; ++i) {
        if (used[i] > 0) result += powerDgt[depth][i] * used[i];
    }
    if (result == 0) return 0;
    n = result;
    do {
        r = n / MAX_BASE;
        used[n-r*MAX_BASE]--;
        n = r;
        depth--;
    } while (r);
    if (depth) return 0;
    i = 1;
    while (i < MAX_BASE && used[i] == 0) i++;
    if (i >= MAX_BASE) numbers[nCount++] = result;
    return 0;
}

void nextDigit(int dgt, int depth) {
    int i, used[MAX_BASE];
    if (depth < MAX_BASE-1) {
        for (i = dgt; i < MAX_BASE; ++i) {
            usedDigits[dgt]++;
            nextDigit(i, depth+1);
            usedDigits[dgt]--;
        }
    }
    if (dgt == 0) dgt = 1;
    for (i = dgt; i < MAX_BASE; ++i) {
        usedDigits[i]++;
        memcpy(used, usedDigits, sizeof(usedDigits));
        calcNum(depth, used);
        usedDigits[i]--;
    }
}

int main() {
    int i, j;
    ulong t;
    initPowerDgt();
    nextDigit(0, 0);

    // sort and remove duplicates
    for (i = 0; i < nCount-1; ++i) {
        for (j = i + 1; j < nCount; ++j) {
            if (numbers[j] < numbers[i]) {
                t = numbers[i];
                numbers[i] = numbers[j];
                numbers[j] = t;
            }
        }
    }
    j = 0;
    for (i = 1; i < nCount; ++i) {
        if (numbers[i] != numbers[j]) {
            j++;
            t = numbers[i];
            numbers[i] = numbers[j];
            numbers[j] = t;
        }
    }
    printf("Own digits power sums for N = 3 to 9 inclusive:\n");
    for (i = 0; i <= j; ++i) printf("%lld\n", numbers[i]);
    return 0;
}
