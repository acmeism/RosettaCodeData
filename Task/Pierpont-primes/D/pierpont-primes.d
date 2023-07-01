import std.algorithm;
import std.bigint;
import std.random;
import std.stdio;

immutable PRIMES = [
      2,   3,   5,   7,  11,  13,  17,  19,  23,  29,  31,  37,  41,  43, 47,
     53,  59,  61,  67,  71,  73,  79,  83,  89,  97, 101, 103, 107, 109, 113,
    127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197,
    199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281,
    283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379,
    383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463,
    467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571,
    577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659,
    661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761,
    769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863,
    877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977,
];

BigInt getRandom(BigInt min, BigInt max) {
    auto r = max - min;
    auto hs = r.toHex;

    BigInt result;
    do {
        string t = "0x";
        for (int i = 0; i < hs.length; i++) {
            t ~= "0123456789abcdef"[uniform(0, 16)];
        }
        result = BigInt(t) + min;
    } while (result < min || max <= result);
    return result;
}

//Modified from https://rosettacode.org/wiki/Miller-Rabin_primality_test#Python
bool isProbablePrime(BigInt n) {
    if (n == 0 || n == 1) {
        return false;
    }

    bool check(BigInt num) {
        foreach (prime; PRIMES) {
            if (num == prime) {
                return true;
            }
            if (num % prime == 0) {
                return false;
            }
            if (prime * prime > num) {
                return true;
            }
        }
        return true;
    }

    if (check(n)) {
        auto large = PRIMES[$ - 1];
        if (n <= large) {
            return true;
        }
    }

    int s = 0;
    auto d = n - 1;
    while ((d & 1) == 0) {
        d >>= 1;
        s++;
    }

    bool trialComposite(BigInt a) {
        if (powmod(a, d, n) == 1) {
            return false;
        }
        for (int i = 0; i < s; i++) {
            auto t = BigInt(2) ^^ i;
            if (powmod(a, t * d, n) == n - 1) {
                return false;
            }
        }
        return true;
    }

    for (int i = 0; i < 8; i++) {
        auto a = getRandom(BigInt(2), n);
        if (trialComposite(a)) {
            return false;
        }
    }
    return true;
}

BigInt[][] pierpont(int n) {
    BigInt[][] p = [[], []];
    for (int i = 0; i < n; i++) {
        p[0] ~= BigInt(0);
        p[1] ~= BigInt(0);
    }
    p[0][0] = 2;

    int count = 0;
    int count1 = 1;
    int count2 = 0;
    BigInt[] s = [BigInt(1)];
    int i2 = 0;
    int i3 = 0;
    int k = 1;
    BigInt n2, n3, t;

    while (count < n) {
        n2 = s[i2] * 2;
        n3 = s[i3] * 3;
        if (n2 < n3) {
            t = n2;
            i2++;
        } else {
            t = n3;
            i3++;
        }
        if (t > s[k - 1]) {
            s ~= t;
            k++;

            t++;
            if (count1 < n && t.isProbablePrime()) {
                p[0][count1] = t;
                count1++;
            }

            t -= 2;
            if (count2 < n && t.isProbablePrime()) {
                p[1][count2] = t;
                count2++;
            }

            count = min(count1, count2);
        }
    }

    return p;
}

void main() {
    auto p = pierpont(250);

    writeln("First 50 Pierpont primes of the first kind:");
    for (int i = 0; i < 50; i++) {
        writef("%8d ", p[0][i]);
        if ((i - 9) % 10 == 0) {
            writeln;
        }
    }
    writeln;

    writeln("First 50 Pierpont primes of the first kind:");
    for (int i = 0; i < 50; i++) {
        writef("%8d ", p[1][i]);
        if ((i - 9) % 10 == 0) {
            writeln;
        }
    }
    writeln;

    writefln("%dth Pierpont prime of the first kind: %d", p[0].length, p[0][$ - 1]);
    writefln("%dth Pierpont prime of the second kind: %d", p[1].length, p[1][$ - 1]);
}
