#include <stdio.h>
#include <stdlib.h>

int turn(int base, int n) {
    int sum = 0;
    while (n != 0) {
        int rem = n % base;
        n = n / base;
        sum += rem;
    }
    return sum % base;
}

void fairshare(int base, int count) {
    int i;

    printf("Base %2d:", base);
    for (i = 0; i < count; i++) {
        int t = turn(base, i);
        printf(" %2d", t);
    }
    printf("\n");
}

void turnCount(int base, int count) {
    int *cnt = calloc(base, sizeof(int));
    int i, minTurn, maxTurn, portion;

    if (NULL == cnt) {
        printf("Failed to allocate space to determine the spread of turns.\n");
        return;
    }

    for (i = 0; i < count; i++) {
        int t = turn(base, i);
        cnt[t]++;
    }

    minTurn = INT_MAX;
    maxTurn = INT_MIN;
    portion = 0;
    for (i = 0; i < base; i++) {
        if (cnt[i] > 0) {
            portion++;
        }
        if (cnt[i] < minTurn) {
            minTurn = cnt[i];
        }
        if (cnt[i] > maxTurn) {
            maxTurn = cnt[i];
        }
    }

    printf("  With %d people: ", base);
    if (0 == minTurn) {
        printf("Only %d have a turn\n", portion);
    } else if (minTurn == maxTurn) {
        printf("%d\n", minTurn);
    } else {
        printf("%d or %d\n", minTurn, maxTurn);
    }

    free(cnt);
}

int main() {
    fairshare(2, 25);
    fairshare(3, 25);
    fairshare(5, 25);
    fairshare(11, 25);

    printf("How many times does each get a turn in 50000 iterations?\n");
    turnCount(191, 50000);
    turnCount(1377, 50000);
    turnCount(49999, 50000);
    turnCount(50000, 50000);
    turnCount(50001, 50000);

    return 0;
}
