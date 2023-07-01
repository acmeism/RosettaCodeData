#include "stdio.h"
#include "stdbool.h"

#define ARRAY_LEN(a,T) (sizeof(a) / sizeof(T))

struct Interval {
    int start, end;
    bool print;
};

int main() {
    struct Interval intervals[] = {
        {2, 1000, true},
        {1000, 4000, true},
        {2, 10000, false},
        {2, 100000, false},
        {2, 1000000, false},
        {2, 10000000, false},
        {2, 100000000, false},
        {2, 1000000000, false},
    };
    int idx;

    for (idx = 0; idx < ARRAY_LEN(intervals, struct Interval); ++idx) {
        struct Interval intv = intervals[idx];
        int count = 0, i;

        if (intv.start == 2) {
            printf("eban numbers up to and including %d:\n", intv.end);
        } else {
            printf("eban numbers between %d and %d (inclusive:)", intv.start, intv.end);
        }

        for (i = intv.start; i <= intv.end; i += 2) {
            int b = i / 1000000000;
            int r = i % 1000000000;
            int m = r / 1000000;
            int t;

            r = i % 1000000;
            t = r / 1000;
            r %= 1000;
            if (m >= 30 && m <= 66) m %= 10;
            if (t >= 30 && t <= 66) t %= 10;
            if (r >= 30 && r <= 66) r %= 10;
            if (b == 0 || b == 2 || b == 4 || b == 6) {
                if (m == 0 || m == 2 || m == 4 || m == 6) {
                    if (t == 0 || t == 2 || t == 4 || t == 6) {
                        if (r == 0 || r == 2 || r == 4 || r == 6) {
                            if (intv.print) printf("%d ", i);
                            count++;
                        }
                    }
                }
            }
        }
        if (intv.print) {
            printf("\n");
        }
        printf("count = %d\n\n", count);
    }

    return 0;
}
