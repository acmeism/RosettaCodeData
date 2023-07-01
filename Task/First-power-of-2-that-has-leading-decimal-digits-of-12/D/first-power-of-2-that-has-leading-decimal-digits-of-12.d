import std.math;
import std.stdio;

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
        val = cast(int)(factor * pow(10.0, fmod(test * logv, 1)));
        if (val == l) {
            n--;
        }
    }
    return test;
}

void runTest(int l, int n) {
    writefln("p(%d, %d) = %d", l, n, p(l, n));
}

void main() {
    runTest(12, 1);
    runTest(12, 2);
    runTest(123, 45);
    runTest(123, 12345);
    runTest(123, 678910);
}
