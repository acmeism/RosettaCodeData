import std.algorithm;
import std.array;
import std.conv;
import std.datetime.stopwatch;
import std.math;
import std.stdio;

struct Term {
    ulong coeff;
    byte ix1, ix2;
}

enum maxDigits = 16;

ulong toUlong(byte[] digits, bool reverse) {
    ulong sum = 0;
    if (reverse) {
        for (int i = digits.length - 1; i >= 0; --i) {
            sum = sum * 10 + digits[i];
        }
    } else {
        for (size_t i = 0; i < digits.length; ++i) {
            sum = sum * 10 + digits[i];
        }
    }
    return sum;
}

bool isSquare(ulong n) {
    if ((0x202021202030213 & (1 << (n & 63))) != 0) {
        auto root = cast(ulong)sqrt(cast(double)n);
        return root * root == n;
    }
    return false;
}

byte[] seq(byte from, byte to, byte step) {
    byte[] res;
    for (auto i = from; i <= to; i += step) {
        res ~= i;
    }
    return res;
}

string commatize(ulong n) {
    auto s = n.to!string;
    auto le = s.length;
    for (int i = le - 3; i >= 1; i -= 3) {
        s = s[0..i] ~ "," ~ s[i..$];
    }
    return s;
}

void main() {
    auto sw = StopWatch(AutoStart.yes);
    ulong pow = 1;
    writeln("Aggregate timings to process all numbers up to:");
    // terms of (n-r) expression for number of digits from 2 to maxDigits
    Term[][] allTerms = uninitializedArray!(Term[][])(maxDigits - 1);
    for (auto r = 2; r <= maxDigits; r++) {
        Term[] terms;
        pow *= 10;
        ulong pow1 = pow;
        ulong pow2 = 1;
        byte i1 = 0;
        byte i2 = cast(byte)(r - 1);
        while (i1 < i2) {
            terms ~= Term(pow1 - pow2, i1, i2);

            pow1 /= 10;
            pow2 *= 10;

            i1++;
            i2--;
        }
        allTerms[r - 2] = terms;
    }
    //  map of first minus last digits for 'n' to pairs giving this value
    byte[][][byte] fml = [
        0: [[2, 2], [8, 8]],
        1: [[6, 5], [8, 7]],
        4: [[4, 0]],
        6: [[6, 0], [8, 2]]
    ];
    // map of other digit differences for 'n' to pairs giving this value
    byte[][][byte] dmd;
    for (byte i = 0; i < 100; i++) {
        byte[] a = [i / 10, i % 10];
        auto d = a[0] - a[1];
        dmd[cast(byte)d] ~= a;
    }
    byte[] fl = [0, 1, 4, 6];
    auto dl = seq(-9, 9, 1);    // all differences
    byte[] zl = [0];            // zero diferences only
    auto el = seq(-8, 8, 2);    // even differences only
    auto ol = seq(-9, 9, 2);    // odd differences only
    auto il = seq(0, 9, 1);
    ulong[] rares;
    byte[][][] lists = uninitializedArray!(byte[][][])(4);
    foreach (i, f; fl) {
        lists[i] = [[f]];
    }
    byte[] digits;
    int count = 0;

    // Recursive closure to generate (n+r) candidates from (n-r) candidates
    // and hence find Rare numbers with a given number of digits.
    void fnpr(byte[] cand, byte[] di, byte[][] dis, byte[][] indicies, ulong nmr, int nd, int level) {
        if (level == dis.length) {
            digits[indicies[0][0]] = fml[cand[0]][di[0]][0];
            digits[indicies[0][1]] = fml[cand[0]][di[0]][1];
            auto le = di.length;
            if (nd % 2 == 1) {
                le--;
                digits[nd / 2] = di[le];
            }
            foreach (i, d; di[1..le]) {
                digits[indicies[i + 1][0]] = dmd[cand[i + 1]][d][0];
                digits[indicies[i + 1][1]] = dmd[cand[i + 1]][d][1];
            }
            auto r = toUlong(digits, true);
            auto npr = nmr + 2 * r;
            if (!isSquare(npr)) {
                return;
            }
            count++;
            writef("     R/N %2d:", count);
            auto ms = sw.peek();
            writef("  %9s", ms);
            auto n = toUlong(digits, false);
            writef("  (%s)\n", commatize(n));
            rares ~= n;
        } else {
            foreach (num; dis[level]) {
                di[level] = num;
                fnpr(cand, di, dis, indicies, nmr, nd, level + 1);
            }
        }
    }

    // Recursive closure to generate (n-r) candidates with a given number of digits.
    void fnmr(byte[] cand, byte[][] list, byte[][] indicies, int nd, int level) {
        if (level == list.length) {
            ulong nmr, nmr2;
            foreach (i, t; allTerms[nd - 2]) {
                if (cand[i] >= 0) {
                    nmr += t.coeff * cand[i];
                } else {
                    nmr2 += t.coeff * -cast(int)(cand[i]);
                    if (nmr >= nmr2) {
                        nmr -= nmr2;
                        nmr2 = 0;
                    } else {
                        nmr2 -= nmr;
                        nmr = 0;
                    }
                }
            }
            if (nmr2 >= nmr) {
                return;
            }
            nmr -= nmr2;
            if (!isSquare(nmr)) {
                return;
            }
            byte[][] dis;
            dis ~= seq(0, cast(byte)(fml[cand[0]].length - 1), 1);
            for (auto i = 1; i < cand.length; i++) {
                dis ~= seq(0, cast(byte)(dmd[cand[i]].length - 1), 1);
            }
            if (nd % 2 == 1) {
                dis ~= il;
            }
            byte[] di = uninitializedArray!(byte[])(dis.length);
            fnpr(cand, di, dis, indicies, nmr, nd, 0);
        } else {
            foreach (num; list[level]) {
                cand[level] = num;
                fnmr(cand, list, indicies, nd, level + 1);
            }
        }
    }

    for (int nd = 2; nd <= maxDigits; nd++) {
        digits = uninitializedArray!(byte[])(nd);
        if (nd == 4) {
            lists[0] ~= zl;
            lists[1] ~= ol;
            lists[2] ~= el;
            lists[3] ~= ol;
        } else if (allTerms[nd - 2].length > lists[0].length) {
            for (int i = 0; i < 4; i++) {
                lists[i] ~= dl;
            }
        }
        byte[][] indicies;
        foreach (t; allTerms[nd - 2]) {
            indicies ~= [t.ix1, t.ix2];
        }
        foreach (list; lists) {
            byte[] cand = uninitializedArray!(byte[])(list.length);
            fnmr(cand, list, indicies, nd, 0);
        }
        auto ms = sw.peek();
        writefln("  %2d digits:  %9s", nd, ms);
    }

    rares.sort;
    writefln("\nThe rare numbers with up to %d digits are:", maxDigits);
    foreach (i, rare; rares) {
        writefln("  %2d:  %25s", i + 1, commatize(rare));
    }
}
