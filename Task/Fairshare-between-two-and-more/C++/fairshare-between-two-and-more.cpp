#include <iostream>
#include <vector>

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
    printf("Base %2d:", base);
    for (int i = 0; i < count; i++) {
        int t = turn(base, i);
        printf(" %2d", t);
    }
    printf("\n");
}

void turnCount(int base, int count) {
    std::vector<int> cnt(base, 0);

    for (int i = 0; i < count; i++) {
        int t = turn(base, i);
        cnt[t]++;
    }

    int minTurn = INT_MAX;
    int maxTurn = INT_MIN;
    int portion = 0;
    for (int i = 0; i < base; i++) {
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
