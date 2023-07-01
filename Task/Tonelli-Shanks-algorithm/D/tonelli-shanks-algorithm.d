import std.bigint;
import std.stdio;
import std.typecons;

alias Pair = Tuple!(long, "n", long, "p");

enum BIGZERO = BigInt("0");
enum BIGONE = BigInt("1");
enum BIGTWO = BigInt("2");
enum BIGTEN = BigInt("10");

struct Solution {
    BigInt root1, root2;
    bool exists;
}

/// https://en.wikipedia.org/wiki/Modular_exponentiation#Right-to-left_binary_method
BigInt modPow(BigInt b, BigInt e, BigInt n) {
    if (n == 1) return BIGZERO;
    BigInt result = 1;
    b = b % n;
    while (e > 0) {
        if (e % 2 == 1) {
            result = (result * b) % n;
        }
        e >>= 1;
        b = (b*b) % n;
    }
    return result;
}

Solution ts(long n, long p) {
    return ts(BigInt(n), BigInt(p));
}

Solution ts(BigInt n, BigInt p) {
    auto powMod(BigInt a, BigInt e) {
        return a.modPow(e, p);
    }

    auto ls(BigInt a) {
        return powMod(a, (p-1)/2);
    }

    if (ls(n) != 1) return Solution(BIGZERO, BIGZERO, false);
    auto q = p - 1;
    auto ss = BIGZERO;
    while ((q & 1) == 0) {
        ss = ss + 1;
        q = q >> 1;
    }

    if (ss == BIGONE) {
        auto r1 = powMod(n, (p + 1) / 4);
        return Solution(r1, p - r1, true);
    }

    auto z = BIGTWO;
    while (ls(z) != p - 1) z = z + 1;
    auto c = powMod(z, q);
    auto r = powMod(n, (q + 1) / 2);
    auto t = powMod(n, q);
    auto m = ss;

    while (true) {
        if (t == 1) return Solution(r, p - r, true);
        auto i = BIGZERO;
        auto zz = t;
        while (zz != 1 && i < m - 1) {
            zz  = zz * zz % p;
            i = i + 1;
        }
        auto b = c;
        auto e = m - i - 1;
        while (e > 0) {
            b = b * b % p;
            e = e - 1;
        }
        r = r * b % p;
        c = b * b % p;
        t = t * c % p;
        m = i;
    }
}

void main() {
    auto pairs = [
        Pair(             10L,                13L),
        Pair(             56L,               101L),
        Pair(          1_030L,            10_009L),
        Pair(          1_032L,            10_009L),
        Pair(         44_402L,           100_049L),
        Pair(    665_820_697L,     1_000_000_009L),
        Pair(881_398_088_036L, 1_000_000_000_039L),
    ];

    foreach (pair; pairs) {
        auto sol = ts(pair.n, pair.p);

        writeln("n = ", pair.n);
        writeln("p = ", pair.p);
        if (sol.exists) {
            writeln("root1 = ", sol.root1);
            writeln("root2 = ", sol.root2);
        }
        else writeln("No solution exists");
        writeln();
    }

    auto bn = BigInt("41660815127637347468140745042827704103445750172002");
    auto bp = BIGTEN ^^ 50 + 577L;
    auto sol = ts(bn, bp);
    writeln("n = ", bn);
    writeln("p = ", bp);
    if (sol.exists) {
        writeln("root1 = ", sol.root1);
        writeln("root2 = ", sol.root2);
    }
    else writeln("No solution exists");
}
