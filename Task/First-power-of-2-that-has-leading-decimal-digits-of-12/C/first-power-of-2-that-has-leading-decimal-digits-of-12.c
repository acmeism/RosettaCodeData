#include <math.h>
#include <stdio.h>

int p(int l, int n) {
    int test = 0;
    double logv = log(2.0) / log(10.0);
    int factor = 1;
    int loop = l;
    while (loop > 10) {
        factor *= 10;
        loop /= 10;
    }
    while (n > 0) {
        int val;

        test++;
        val = (int)(factor * pow(10.0, fmod(test * logv, 1)));
        if (val == l) {
            n--;
        }
    }
    return test;
}

void runTest(int l, int n) {
    printf("p(%d, %d) = %d\n", l, n, p(l, n));
}

int main() {
    runTest(12, 1);
    runTest(12, 2);
    runTest(123, 45);
    runTest(123, 12345);
    runTest(123, 678910);

    return 0;
}
