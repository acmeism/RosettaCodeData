#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const int PRIMES[] = {
      2,   3,   5,   7,  11,  13,  17,  19,  23,  29,  31,  37,  41,  43,  47,
     53,  59,  61,  67,  71,  73,  79,  83,  89,  97, 101, 103, 107, 109, 113,
    127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197,
    199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281,
    283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379,
    383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463,
    467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571,
    577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659,
    661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761,
    769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863,
    877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977,
};
#define PRIME_SIZE (sizeof(PRIMES) / sizeof(int))

bool isPrime(const int n) {
    int i;

    if (n < 2) {
        return false;
    }

    for (i = 0; i < PRIME_SIZE; i++) {
        if (n == PRIMES[i]) {
            return true;
        }
        if (n % PRIMES[i] == 0) {
            return false;
        }
    }

    if (n < PRIMES[PRIME_SIZE - 1] * PRIMES[PRIME_SIZE - 1]) {
        return true;
    }

    i = PRIMES[PRIME_SIZE - 1]+2;
    while (i * i < n) {
        if (n % i == 0) {
            return false;
        }
        i += 2;
    }

    return true;
}

#define N 50
int p[2][50];
void pierpont() {
    int64_t s[8 * N];
    int count = 0;
    int count1 = 1;
    int count2 = 0;
    int i2 = 0;
    int i3 = 0;
    int k = 1;
    int64_t n2, n3, t;
    int64_t *sp = &s[1];

    memset(p[0], 0, N * sizeof(int));
    memset(p[1], 0, N * sizeof(int));
    p[0][0] = 2;
    s[0] = 1;

    while (count < N) {
        n2 = s[i2] * 2;
        n3 = s[i3] * 3;
        if (n2 < n3) {
            t = n2;
            i2++;
        } else {
            t = n3;
            i3++;
        }
        if (t > s[k - 1]) {
            *sp++ = t;
            k++;

            t++;
            if (count1 < N && isPrime(t)) {
                p[0][count1] = t;
                count1++;
            }

            t -= 2;
            if (count2 < N && isPrime(t)) {
                p[1][count2] = t;
                count2++;
            }

            count = min(count1, count2);
        }
    }
}

int main() {
    int i;

    pierpont();

    printf("First 50 Pierpont primes of the first kind:\n");
    for (i = 0; i < N; i++) {
        printf("%8d ", p[0][i]);
        if ((i - 9) % 10 == 0) {
            printf("\n");
        }
    }
    printf("\n");

    printf("First 50 Pierpont primes of the second kind:\n");
    for (i = 0; i < N; i++) {
        printf("%8d ", p[1][i]);
        if ((i - 9) % 10 == 0) {
            printf("\n");
        }
    }
    printf("\n");
}
