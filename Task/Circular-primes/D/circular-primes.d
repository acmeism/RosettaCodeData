import std.bigint;
import std.stdio;

immutable PRIMES = [
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,
    101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199,
    211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293,
    307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397,
    401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499,
    503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599,
    601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691,
    701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797,
    809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887,
    907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997
];

bool isPrime(BigInt n) {
    if (n < 2) {
        return false;
    }

    foreach (p; PRIMES) {
        if (n == p) {
            return true;
        }
        if (n % p == 0) {
            return false;
        }
        if (p * p > n) {
            return true;
        }
    }

    for (auto m = BigInt(PRIMES[$ - 1]); m * m <= n ; m += 2) {
        if (n % m == 0) {
            return false;
        }
    }

    return true;
}

// e.g. returns 2341 if n = 1234
BigInt cycle(BigInt n) {
    BigInt m = n;
    BigInt p = 1;
    while (m >= 10) {
        p *= 10;
        m /= 10;
    }
    return m + 10 * (n % p);
}

bool isCircularPrime(BigInt p) {
    if (!isPrime(p)) {
        return false;
    }
    for (auto p2 = cycle(p); p2 != p; p2 = cycle(p2)) {
        if (p2 < p || !isPrime(p2)) {
            return false;
        }
    }
    return true;
}

BigInt repUnit(int len) {
    BigInt n = 0;
    while (len > 0) {
        n = 10 * n + 1;
        len--;
    }
    return n;
}

void main() {
    writeln("First 19 circular primes:");
    int count = 0;
    foreach (p; PRIMES) {
        if (isCircularPrime(BigInt(p))) {
            if (count > 0) {
                write(", ");
            }
            write(p);
            count++;
        }
    }
    for (auto p = BigInt(PRIMES[$ - 1]) + 2; count < 19; p += 2) {
        if (isCircularPrime(BigInt(p))) {
            if (count > 0) {
                write(", ");
            }
            write(p);
            count++;
        }
    }
    writeln;
}
