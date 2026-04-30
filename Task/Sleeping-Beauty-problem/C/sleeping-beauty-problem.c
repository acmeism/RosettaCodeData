#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define N 1000000

bool coin_toss() {
    return rand() & 1;
}

double run_experiment(int amount) {
    int wakings = 0;
    int wakings_heads = 0;

    for (int i=0; i<amount; i++) {
        bool heads = coin_toss();

        /* Wake up on Monday */
        wakings++;
        if (heads) {
            wakings_heads++;
            continue;
        }

        /* Wake up on Tuesday */
        wakings++;
    }

    return (double)wakings_heads/(double)wakings;
}

int main(void) {
    double chance = run_experiment(N);
    printf("Chance of waking up with heads: %f\n", chance);
    return 0;
}
