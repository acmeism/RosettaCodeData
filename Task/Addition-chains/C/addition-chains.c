#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TRUE 1
#define FALSE 0

typedef int bool;

typedef struct {
    int x, y;
} pair;

int* example = NULL;
int exampleLen = 0;

void reverse(int s[], int len) {
    int i, j, t;
    for (i = 0, j = len - 1; i < j; ++i, --j) {
        t = s[i];
        s[i] = s[j];
        s[j] = t;
    }
}

pair tryPerm(int i, int pos, int seq[], int n, int len, int minLen);

pair checkSeq(int pos, int seq[], int n, int len, int minLen) {
    pair p;
    if (pos > minLen || seq[0] > n) {
        p.x = minLen; p.y = 0;
        return p;
    }
    else if (seq[0] == n) {
        example = malloc(len * sizeof(int));
        memcpy(example, seq, len * sizeof(int));
        exampleLen = len;
        p.x = pos; p.y = 1;
        return p;
    }
    else if (pos < minLen) {
        return tryPerm(0, pos, seq, n, len, minLen);
    }
    else {
        p.x = minLen; p.y = 0;
        return p;
    }
}

pair tryPerm(int i, int pos, int seq[], int n, int len, int minLen) {
    int *seq2;
    pair p, res1, res2;
    size_t size = sizeof(int);
    if (i > pos) {
        p.x = minLen; p.y = 0;
        return p;
    }
    seq2 = malloc((len + 1) * size);
    memcpy(seq2 + 1, seq, len * size);
    seq2[0] = seq[0] + seq[i];
    res1 = checkSeq(pos + 1, seq2, n, len + 1, minLen);
    res2 = tryPerm(i + 1, pos, seq, n, len, res1.x);
    free(seq2);
    if (res2.x < res1.x)
        return res2;
    else if (res2.x == res1.x) {
        p.x = res2.x; p.y = res1.y + res2.y;
        return p;
    }
    else {
        printf("Error in tryPerm\n");
        p.x = 0; p.y = 0;
        return p;
    }
}

pair initTryPerm(int x, int minLen) {
    int seq[1] = {1};
    return tryPerm(0, 0, seq, x, 1, minLen);
}

void printArray(int a[], int len) {
    int i;
    printf("[");
    for (i = 0; i < len; ++i) printf("%d ", a[i]);
    printf("\b]\n");
}

bool isBrauer(int a[], int len) {
    int i, j;
    bool ok;
    for (i = 2; i < len; ++i) {
        ok = FALSE;
        for (j = i - 1; j >= 0; j--) {
            if (a[i-1] + a[j] == a[i]) {
                ok = TRUE;
                break;
            }
        }
        if (!ok) return FALSE;
    }
    return TRUE;
}

bool isAdditionChain(int a[], int len) {
    int i, j, k;
    bool ok, exit;
    for (i = 2; i < len; ++i) {
        if (a[i] > a[i - 1] * 2) return FALSE;
        ok = FALSE; exit = FALSE;
        for (j = i - 1; j >= 0; --j) {
            for (k = j; k >= 0; --k) {
               if (a[j] + a[k] == a[i]) { ok = TRUE; exit = TRUE; break; }
            }
            if (exit) break;
        }
        if (!ok) return FALSE;
    }
    if (example == NULL && !isBrauer(a, len)) {
        example = malloc(len * sizeof(int));
        memcpy(example, a, len * sizeof(int));
        exampleLen = len;
    }
    return TRUE;
}

void nextChains(int index, int len, int seq[], int *pcount) {
    for (;;) {
        int i;
        if (index < len - 1) {
           nextChains(index + 1, len, seq, pcount);
        }
        if (seq[index] + len - 1 - index >= seq[len - 1]) return;
        seq[index]++;
        for (i = index + 1; i < len - 1; ++i) {
            seq[i] = seq[i-1] + 1;
        }
        if (isAdditionChain(seq, len)) (*pcount)++;
    }
}

int findNonBrauer(int num, int len, int brauer) {
    int i, count = 0;
    int *seq = malloc(len * sizeof(int));
    seq[0] = 1;
    seq[len - 1] = num;
    for (i = 1; i < len - 1; ++i) {
        seq[i] = seq[i - 1] + 1;
    }
    if (isAdditionChain(seq, len)) count = 1;
    nextChains(2, len, seq, &count);
    free(seq);
    return count - brauer;
}

void findBrauer(int num, int minLen, int nbLimit) {
    pair p = initTryPerm(num, minLen);
    int actualMin = p.x, brauer = p.y, nonBrauer;
    printf("\nN = %d\n", num);
    printf("Minimum length of chains : L(%d) = %d\n", num, actualMin);
    printf("Number of minimum length Brauer chains : %d\n", brauer);
    if (brauer > 0) {
        printf("Brauer example : ");
        reverse(example, exampleLen);
        printArray(example, exampleLen);
    }
    if (example != NULL) {
        free(example);
        example = NULL;
        exampleLen = 0;
    }
    if (num <= nbLimit) {
        nonBrauer = findNonBrauer(num, actualMin + 1, brauer);
        printf("Number of minimum length non-Brauer chains : %d\n", nonBrauer);
        if (nonBrauer > 0) {
            printf("Non-Brauer example : ");
            printArray(example, exampleLen);
        }
        if (example != NULL) {
            free(example);
            example = NULL;
            exampleLen = 0;
        }
    }
    else {
        printf("Non-Brauer analysis suppressed\n");
    }
}

int main() {
    int i;
    int nums[12] = {7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379};
    printf("Searching for Brauer chains up to a minimum length of 12:\n");
    for (i = 0; i < 12; ++i) findBrauer(nums[i], 12, 79);
    return 0;
}
