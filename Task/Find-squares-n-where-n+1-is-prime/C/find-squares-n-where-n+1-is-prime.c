#include <stdio.h>
#include <stdbool.h>
#include <math.h>

#define MAX 1000

void sieve(int n, bool *prime) {
    prime[0] = prime[1] = false;
    for (int i=2; i<=n; i++) prime[i] = true;
    for (int p=2; p*p<=n; p++)
        if (prime[p])
            for (int c=p*p; c<=n; c+=p) prime[c] = false;
}

bool square(int n) {
    int sq = sqrt(n);
    return (sq * sq == n);
}

int main() {
    bool prime[MAX + 1];
    sieve(MAX, prime);
    for (int i=2; i<=MAX; i++) if (prime[i]) {
        int sq = i-1;
        if (square(sq)) printf("%d ", sq);
    }
    printf("\n");
    return 0;
}
