import std.stdio;

struct Interval {
    int start, end;
    bool print;
}

void main() {
    Interval[] intervals = [
        {2, 1_000, true},
        {1_000, 4_000, true},
        {2, 10_000, false},
        {2, 100_000, false},
        {2, 1_000_000, false},
        {2, 10_000_000, false},
        {2, 100_000_000, false},
        {2, 1_000_000_000, false},
    ];
    foreach (intv; intervals) {
        if (intv.start == 2) {
            writeln("eban numbers up to an including ", intv.end, ':');
        } else {
            writeln("eban numbers between ", intv.start ," and ", intv.end, " (inclusive):");
        }

        int count;
        for (int i = intv.start; i <= intv.end; i = i + 2) {
            int b = i / 1_000_000_000;
            int r = i % 1_000_000_000;
            int m = r / 1_000_000;
            r = i % 1_000_000;
            int t = r / 1_000;
            r %= 1_000;
            if (m >= 30 && m <= 66) m %= 10;
            if (t >= 30 && t <= 66) t %= 10;
            if (r >= 30 && r <= 66) r %= 10;
            if (b == 0 || b == 2 || b == 4 || b == 6) {
                if (m == 0 || m == 2 || m == 4 || m == 6) {
                    if (t == 0 || t == 2 || t == 4 || t == 6) {
                        if (r == 0 || r == 2 || r == 4 || r == 6) {
                            if (intv.print) write(i, ' ');
                            count++;
                        }
                    }
                }
            }
        }
        if (intv.print) {
            writeln();
        }
        writeln("count = ", count);
        writeln;
    }
}
