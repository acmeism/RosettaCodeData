#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double signum(double i) {
    if (i != floor(i)) {
        fprintf(stderr, "Argument must be integral.\n");
        exit(1);
    }
    return i > 0.0 ? 1 : i < 0.0 ? -1 : signbit(i) ? -0.0 : 0.0;
}

int main() {
    double ints[4] = {5.0, 0.0, -5.0, -0.0};
    for (int j = 0; j < 4; ++j) printf("%g -> %g\n", ints[j], signum(ints[j]));
    return 0;
}
