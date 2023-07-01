import std.bigint;
import std.math;
import std.stdio;

bool isPrime(long test) {
    if (test == 2) {
        return true;
    }
    if (test % 2 == 0) {
        return false;
    }
    for (long d = 3 ; d * d <= test; d += 2) {
        if (test % d == 0) {
            return false;
        }
    }
    return true;
}

int[] calcSmallPrimes(int numPrimes) {
    int[] smallPrimes;
    smallPrimes ~= 2;

    int count = 0;
    int n = 3;
    while (count < numPrimes) {
        if (isPrime(n)) {
            smallPrimes ~= n;
            count++;
        }
        n += 2;
    }

    return smallPrimes;
}

immutable MAX = 45;
immutable smallPrimes = calcSmallPrimes(MAX);

int getDivisorCount(long n) {
    int count = 1;
    while (n % 2 == 0) {
        n /= 2;
        count += 1;
    }
    for (long d = 3; d * d <= n; d += 2) {
        long q = n / d;
        long r = n % d;
        int dc = 0;
        while (r == 0) {
            dc += count;
            n = q;
            q = n / d;
            r = n % d;
        }
        count += dc;
    }
    if (n != 1) {
        count *= 2;
    }
    return count;
}

BigInt OEISA073916(int n) {
    if (isPrime(n) ) {
        return BigInt(smallPrimes[n-1]) ^^ (n - 1);
    }
    int count = 0;
    int result = 0;
    for (int i = 1; count < n; i++) {
        if (n % 2 == 1) {
            //  The solution for an odd (non-prime) term is always a square number
            int root = cast(int) sqrt(cast(real) i);
            if (root * root != i) {
                continue;
            }
        }
        if (getDivisorCount(i) == n) {
            count++;
            result = i;
        }
    }
    return BigInt(result);
}

void main() {
    foreach (n; 1 .. MAX + 1) {
        writeln("A073916(", n, ") = ", OEISA073916(n));
    }
}
