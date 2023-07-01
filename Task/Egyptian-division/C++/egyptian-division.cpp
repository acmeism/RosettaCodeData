#include <cassert>
#include <iostream>

typedef unsigned long ulong;

/*
 * Remainder is an out paramerter. Use nullptr if the remainder is not needed.
 */
ulong egyptian_division(ulong dividend, ulong divisor, ulong* remainder) {
    constexpr int SIZE = 64;
    ulong powers[SIZE];
    ulong doublings[SIZE];
    int i = 0;

    for (; i < SIZE; ++i) {
        powers[i] = 1 << i;
        doublings[i] = divisor << i;
        if (doublings[i] > dividend) {
            break;
        }
    }

    ulong answer = 0;
    ulong accumulator = 0;

    for (i = i - 1; i >= 0; --i) {
        /*
         * If the current value of the accumulator added to the
         * doublings cell would be less than or equal to the
         * dividend then add it to the accumulator
         */
        if (accumulator + doublings[i] <= dividend) {
            accumulator += doublings[i];
            answer += powers[i];
        }
    }

    if (remainder) {
        *remainder = dividend - accumulator;
    }
    return answer;
}

void print(ulong a, ulong b) {
    using namespace std;

    ulong x, y;
    x = egyptian_division(a, b, &y);

    cout << a << " / " << b << " = " << x << " remainder " << y << endl;
    assert(a == b * x + y);
}

int main() {
    print(580, 34);

    return 0;
}
