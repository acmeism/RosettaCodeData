import std.bigint;
import std.stdio;
import std.typecons;

enum BIGZERO = BigInt(0);

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

alias Point = Tuple!(BigInt, "x", BigInt, "y");
alias Triple = Tuple!(BigInt, "x", BigInt, "y", bool, "b");

Triple c(string ns, string ps) {
    auto n = BigInt(ns);
    BigInt p;
    if (ps.length > 0) {
        p = BigInt(ps);
    } else {
        p = BigInt(10)^^50 + 151;
    }

    // Legendre symbol, returns 1, 0 or p - 1
    auto ls = (BigInt a) => modPow(a, (p-1)/2, p);

    // Step 0, validate arguments
    if (ls(n) != 1) return Triple(BIGZERO, BIGZERO, false);

    // Step 1, find a, omega2
    auto a = BIGZERO;
    BigInt omega2;
    while (true) {
        omega2 = (a * a + p - n) % p;
        if (ls(omega2) == p-1) break;
        a++;
    }

    // multiplication in Fp2
    auto mul = (Point aa, Point bb) => Point(
        (aa.x * bb.x + aa.y * bb.y * omega2) % p,
        (aa.x * bb.y + bb.x * aa.y) % p
    );

    // Step 2, compute power
    auto r = Point(BigInt(1), BIGZERO);
    auto s = Point(a, BigInt(1));
    auto nn = ((p+1) >> 1) % p;
    while (nn > 0) {
        if ((nn & 1) == 1) r = mul(r, s);
        s = mul(s, s);
        nn >>= 1;
    }

    // Step 3, check x in Fp
    if (r.y != 0) return Triple(BIGZERO, BIGZERO, false);

    // Step 5, check x * x = n
    if (r.x*r.x%p!=n) return Triple(BIGZERO, BIGZERO, false);

    // Step 4, solutions
    return Triple(r.x, p-r.x, true);
}

void main() {
    writeln(c("10", "13"));
    writeln(c("56", "101"));
    writeln(c("8218", "10007"));
    writeln(c("8219", "10007"));
    writeln(c("331575", "1000003"));
    writeln(c("665165880", "1000000007"));
    writeln(c("881398088036", "1000000000039"));
    writeln(c("34035243914635549601583369544560650254325084643201", ""));
}
