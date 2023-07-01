#include <math.h>
#include <stdio.h>

const double K = 7.8e9;
const int n0 = 27;
const double actual[] = {
    27, 27, 27, 44, 44, 59, 59, 59, 59, 59, 59, 59, 59, 60, 60,
    61, 61, 66, 83, 219, 239, 392, 534, 631, 897, 1350, 2023, 2820,
    4587, 6067, 7823, 9826, 11946, 14554, 17372, 20615, 24522, 28273,
    31491, 34933, 37552, 40540, 43105, 45177, 60328, 64543, 67103,
    69265, 71332, 73327, 75191, 75723, 76719, 77804, 78812, 79339,
    80132, 80995, 82101, 83365, 85203, 87024, 89068, 90664, 93077,
    95316, 98172, 102133, 105824, 109695, 114232, 118610, 125497,
    133852, 143227, 151367, 167418, 180096, 194836, 213150, 242364,
    271106, 305117, 338133, 377918, 416845, 468049, 527767, 591704,
    656866, 715353, 777796, 851308, 928436, 1000249, 1082054, 1174652
};
const size_t actual_size = sizeof(actual) / sizeof(double);

double f(double r) {
    double sq = 0;
    size_t i;
    for (i = 0; i < actual_size; ++i) {
        double eri = exp(r * i);
        double guess = (n0 * eri) / (1 + n0 * (eri - 1) / K);
        double diff = guess - actual[i];
        sq += diff * diff;
    }
    return sq;
}

double solve(double (*fn)(double), double guess, double epsilon) {
    double delta, f0, factor;
    for (delta = guess ? guess : 1, f0 = fn(guess), factor = 2;
        delta > epsilon && guess != guess - delta;
        delta *= factor) {
        double nf = (*fn)(guess - delta);
        if (nf < f0) {
            f0 = nf;
            guess -= delta;
        } else {
            nf = fn(guess + delta);
            if (nf < f0) {
                f0 = nf;
                guess += delta;
            } else {
                factor = 0.5;
            }
        }
    }
    return guess;
}

double solve_default(double (*fn)(double)) {
    return solve(fn, 0.5, 0);
}

int main() {
    double r = solve_default(f);
    double R0 = exp(12 * r);
    printf("r = %f, R0 = %f\n", r, R0);
    return 0;
}
