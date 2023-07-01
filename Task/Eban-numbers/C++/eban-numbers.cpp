#include <iostream>

struct Interval {
    int start, end;
    bool print;
};

int main() {
    Interval intervals[] = {
        {2, 1000, true},
        {1000, 4000, true},
        {2, 10000, false},
        {2, 100000, false},
        {2, 1000000, false},
        {2, 10000000, false},
        {2, 100000000, false},
        {2, 1000000000, false},
    };

    for (auto intv : intervals) {
        if (intv.start == 2) {
            std::cout << "eban numbers up to and including " << intv.end << ":\n";
        } else {
            std::cout << "eban numbers bwteen " << intv.start << " and " << intv.end << " (inclusive):\n";
        }

        int count = 0;
        for (int i = intv.start; i <= intv.end; i += 2) {
            int b = i / 1000000000;
            int r = i % 1000000000;
            int m = r / 1000000;
            r = i % 1000000;
            int t = r / 1000;
            r %= 1000;
            if (m >= 30 && m <= 66) m %= 10;
            if (t >= 30 && t <= 66) t %= 10;
            if (r >= 30 && r <= 66) r %= 10;
            if (b == 0 || b == 2 || b == 4 || b == 6) {
                if (m == 0 || m == 2 || m == 4 || m == 6) {
                    if (t == 0 || t == 2 || t == 4 || t == 6) {
                        if (r == 0 || r == 2 || r == 4 || r == 6) {
                            if (intv.print) std::cout << i << ' ';
                            count++;
                        }
                    }
                }
            }
        }
        if (intv.print) {
            std::cout << '\n';
        }
        std::cout << "count = " << count << "\n\n";
    }

    return 0;
}
