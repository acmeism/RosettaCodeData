import std.range;
import std.stdio;

int indexOf(Range, Element)(Range haystack, scope Element needle)
if (isInputRange!Range) {
    int idx;
    foreach (straw; haystack) {
        if (straw == needle) {
            return idx;
        }
        idx++;
    }
    return -1;
}

bool getDigits(int n, int le, int[] digits) {
    while (n > 0) {
        auto r = n % 10;
        if (r == 0 || indexOf(digits, r) >= 0) {
            return false;
        }
        le--;
        digits[le] = r;
        n /= 10;
    }
    return true;
}

int removeDigit(int[] digits, int le, int idx) {
    enum pows = [ 1, 10, 100, 1_000, 10_000 ];

    int sum = 0;
    auto pow = pows[le - 2];
    for (int i = 0; i < le; i++) {
        if (i == idx) continue;
        sum += digits[i] * pow;
        pow /= 10;
    }
    return sum;
}

void main() {
    auto lims = [ [ 12, 97 ], [ 123, 986 ], [ 1234, 9875 ], [ 12345, 98764 ] ];
    int[5] count;
    int[10][5] omitted;
    for (int i = 0; i < lims.length; i++) {
        auto nDigits = new int[i + 2];
        auto dDigits = new int[i + 2];
        for (int n = lims[i][0]; n <= lims[i][1]; n++) {
            nDigits[] = 0;
            bool nOk = getDigits(n, i + 2, nDigits);
            if (!nOk) {
                continue;
            }
            for (int d = n + 1; d <= lims[i][1] + 1; d++) {
                dDigits[] = 0;
                bool dOk = getDigits(d, i + 2, dDigits);
                if (!dOk) {
                    continue;
                }
                for (int nix = 0; nix < nDigits.length; nix++) {
                    auto digit = nDigits[nix];
                    auto dix = indexOf(dDigits, digit);
                    if (dix >= 0) {
                        auto rn = removeDigit(nDigits, i + 2, nix);
                        auto rd = removeDigit(dDigits, i + 2, dix);
                        if (cast(double)n / d == cast(double)rn / rd) {
                            count[i]++;
                            omitted[i][digit]++;
                            if (count[i] <= 12) {
                                writefln("%d/%d = %d/%d by omitting %d's", n, d, rn, rd, digit);
                            }
                        }
                    }
                }
            }
        }
        writeln;
    }

    for (int i = 2; i <= 5; i++) {
        writefln("There are %d %d-digit fractions of which:", count[i - 2], i);
        for (int j = 1; j <= 9; j++) {
            if (omitted[i - 2][j] == 0) {
                continue;
            }
            writefln("%6s have %d's omitted", omitted[i - 2][j], j);
        }
        writeln;
    }
}
