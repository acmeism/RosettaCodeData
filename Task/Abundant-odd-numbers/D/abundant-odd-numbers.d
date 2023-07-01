import std.stdio;

int[] divisors(int n) {
    import std.range;

    int[] divs = [1];
    int[] divs2;

    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            int j = n / i;
            divs ~= i;
            if (i != j) {
                divs2 ~= j;
            }
        }
    }
    divs ~= retro(divs2).array;

    return divs;
}

int abundantOdd(int searchFrom, int countFrom, int countTo, bool printOne) {
    import std.algorithm.iteration;
    import std.array;
    import std.conv;

    int count = countFrom;
    int n = searchFrom;
    for (; count < countTo; n += 2) {
        auto divs = divisors(n);
        int tot = sum(divs);
        if (tot > n) {
            count++;
            if (printOne && count < countTo) {
                continue;
            }
            auto s = divs.map!(to!string).join(" + ");
            if (printOne) {
                writefln("%d < %s = %d", n, s, tot);
            } else {
                writefln("%2d. %5d < %s = %d", count, n, s, tot);
            }
        }
    }
    return n;
}

void main() {
    const int max = 25;
    writefln("The first %d abundant odd numbers are:", max);
    int n = abundantOdd(1, 0, 25, false);

    writeln("\nThe one thousandth abundant odd number is:");
    abundantOdd(n, 25, 1000, true);

    writeln("\nThe first abundant odd number above one billion is:");
    abundantOdd(cast(int)(1e9 + 1), 0, 1, true);
}
