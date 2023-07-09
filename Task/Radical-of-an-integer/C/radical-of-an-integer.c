#include <stdio.h>

int radical(int num, int *dps_out) {
    int rad = 1, dps = 0, div;

    if ((num & 1) == 0) {
        while ((num & 1) == 0) num >>= 1;
        rad *= 2;
        dps++;
    }

    for (div = 3; div <= num; div += 2) {
        if (num % div != 0) continue;
        rad *= div;
        dps++;
        while (num % div == 0) num /= div;
    }

    if (dps_out != NULL) *dps_out = dps;
    return rad;
}


void show_first_50() {
    int n;
    printf("Radicals of 1..50:\n");
    for (n = 1; n <= 50; n++) {
        printf("%5d", radical(n, NULL));
        if (n % 5 == 0) printf("\n");
    }
}

void show_rad(int n) {
    printf("The radical of %d is %d.\n", n, radical(n, NULL));
}

void find_distribution() {
    int n, dps, dist[8] = {0};

    for (n = 1; n <= 1000000; n++) {
        printf("%d\r", n);
        radical(n, &dps);
        dist[dps]++;
    }

    printf("Distribution of radicals:\n");
    for (dps = 0; dps < 8; dps++) {
        printf("%d: %d\n", dps, dist[dps]);
    }
}

int main() {
    show_first_50();
    printf("\n");
    show_rad(99999);
    show_rad(499999);
    show_rad(999999);
    printf("\n");
    find_distribution();
    return 0;
}
