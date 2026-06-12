#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#define MAX 100

void sieve(bool *prime, int max) {
    memset(prime, true, max+1);
    prime[0] = prime[1] = false;

    for (int p=2; p*p<=max; p++)
        for (int c=p*p; c<=max; c+=p)
            prime[c] = false;
}

int lo_fac(bool *prime, int n) {
    if (n==1) return 1;
    for (int f=2; f<=n; f++)
        if (prime[f] && n%f == 0) return f;
    return n;
}

int hi_fac(bool *prime, int n) {
    if (n==1) return 1;
    for (int f=n; f>=2; f--)
        if (prime[f] && n%f == 0) return f;
    return n;
}

int main() {
    bool prime[MAX+1];
    sieve(prime, MAX);

    for (int i=1; i<=MAX; i++) {
        printf("%6d", lo_fac(prime, i) * hi_fac(prime, i));
        if (i%10 == 0) printf("\n");
    }
    return 0;
}
