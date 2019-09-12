import std.bigint;
import std.random;
import std.stdio;

struct PExp {
    BigInt prime;
    int exp;
}

BigInt gcd(BigInt x, BigInt y) {
    if (y == 0) {
        return x;
    }
    return gcd(y, x % y);
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

BigInt pow(long b, long e) {
    return pow(BigInt(b), BigInt(e));
}
BigInt pow(BigInt b, BigInt e) {
    if (e == 0) {
        return BigInt(1);
    }

    BigInt result = 1;
    while (e > 1) {
        if (e % 2 == 0) {
            b *= b;
            e /= 2;
        } else {
            result *= b;
            b *= b;
            e = (e - 1) / 2;
        }
    }

    return b * result;
}

BigInt sqrt(BigInt self) {
    BigInt b = self;
    while (true) {
        BigInt a = b;
        b = self / a + a >> 1;
        if (b >= a) return a;
    }
}

long bitLength(BigInt self) {
    BigInt bi = self;
    long length;
    while (bi != 0) {
        length++;
        bi >>= 1;
    }
    return length;
}

PExp[] factor(BigInt n) {
    PExp[] pf;
    BigInt nn = n;
    int b = 0;
    int e = 1;
    while ((nn & e) == 0) {
        e <<= 1;
        b++;
    }
    if (b > 0) {
        nn = nn >> b;
        pf ~= PExp(BigInt(2), b);
    }
    BigInt s = nn.sqrt();
    BigInt d = 3;
    while (nn > 1) {
        if (d > s) d = nn;
        e = 0;
        while (true) {
            BigInt div, rem;
            nn.divMod(d, div, rem);
            if (rem.bitLength > 0) break;
            nn = div;
            e++;
        }
        if (e > 0) {
            pf ~= PExp(d, e);
            s = nn.sqrt();
        }
        d += 2;
    }

    return pf;
}

BigInt moBachShallit58(BigInt a, BigInt n, PExp[] pf) {
    BigInt n1 = n - 1;
    BigInt mo = 1;
    foreach(pe; pf) {
        BigInt y = n1 / pe.prime.pow(BigInt(pe.exp));
        int o = 0;
        BigInt x = a.modPow(y, n);
        while (x > 1) {
            x = x.modPow(pe.prime, n);
            o++;
        }
        BigInt o1 = pe.prime.pow(BigInt(o));
        o1 = o1 / gcd(mo, o1);
        mo = mo * o1;
    }
    return mo;
}

void moTest(ulong a, ulong n) {
    moTest(BigInt(a), n);
}
void moTest(BigInt a, ulong n) {
    // Commented out because the implementations tried all failed for the -2 and -3 tests.
    // if (!n.isProbablePrime()) {
        // writeln("Not computed. Modulus must be prime for this algorithm.");
        // return;
    // }
    if (a.bitLength < 100) {
        write("ord(", a, ")");
    } else {
        write("ord([big])");
    }
    write(" mod ", n, " ");
    BigInt nn = n;
    BigInt mob = moBachShallit58(a, nn, factor(nn - 1));
    writeln("= ", mob);
}

void main() {
    moTest(37, 3343);

    moTest(pow(10, 100) + 1, 7919);
    moTest(pow(10, 1000) + 1, 15485863);
    moTest(pow(10, 10000) - 1, 22801763489);

    moTest(1511678068, 7379191741);
    moTest(3047753288, 2257683301);
}
