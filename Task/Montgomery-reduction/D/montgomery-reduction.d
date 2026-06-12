import std.bigint;
import std.stdio;

int bitLength(BigInt v) {
    if (v < 0) {
        v *= -1;
    }

    int result = 0;
    while (v > 0) {
        v >>= 1;
        result++;
    }

    return result;
}

/// https://en.wikipedia.org/wiki/Modular_exponentiation#Right-to-left_binary_method
BigInt modPow(BigInt b, BigInt e, BigInt n) {
    if (n == 1) return BigInt(0);
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

struct Montgomery {
    BigInt m;
    int n;
    BigInt rrm;

    this(BigInt m) in {
        assert(m > 0 && (m & 1) != 0); // must be positive and odd
    } body {
        this.m = m;
        n = m.bitLength();
        rrm = (BigInt(1) << (n * 2)) % m;
    }

    BigInt reduce(BigInt t) {
        auto a = t;

        foreach(i; 0..n) {
            if ((a & 1) == 1) a += m;
            a = a >> 1;
        }
        if (a >= m) a -= m;
        return a;
    }

    enum BASE = 2;
}

void main() {
    auto m = BigInt("750791094644726559640638407699");
    auto x1 = BigInt("540019781128412936473322405310");
    auto x2 = BigInt("515692107665463680305819378593");

    auto mont = Montgomery(m);
    auto t1 = x1 * mont.rrm;
    auto t2 = x2 * mont.rrm;

    auto r1 = mont.reduce(t1);
    auto r2 = mont.reduce(t2);
    auto r = BigInt(1) << mont.n;

    writeln("b :  ", Montgomery.BASE);
    writeln("n :  ", mont.n);
    writeln("r :  ", r);
    writeln("m :  ", mont.m);
    writeln("t1:  ", t1);
    writeln("t2:  ", t2);
    writeln("r1:  ", r1);
    writeln("r2:  ", r2);
    writeln();
    writeln("Original x1       : ", x1);
    writeln("Recovered from r1 : ", mont.reduce(r1));
    writeln("Original x2       : ", x2);
    writeln("Recovered from r2 : ", mont.reduce(r2));

    writeln("\nMontgomery computation of x1 ^ x2 mod m :");
    auto prod = mont.reduce(mont.rrm);
    auto base = mont.reduce(x1 * mont.rrm);
    auto exp = x2;
    while (exp.bitLength() > 0) {
        if ((exp & 1) == 1) prod = mont.reduce(prod * base);
        exp >>= 1;
        base = mont.reduce(base * base);
    }
    writeln(mont.reduce(prod));
    writeln("\nAlternate computation of x1 ^ x2 mod m :");
    writeln(x1.modPow(x2, m));
}
