import std.stdio;

immutable PRIMES = [
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,
    101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199,
    211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331
];

bool isPrime(const int n) {
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
        if (n < p * p) {
            return true;
        }
    }

    int i = (PRIMES[$ - 1] / 6) * 6 - 1;
    while (i * i <= n) {
        if (n % i == 0) {
            return false;
        }
        i += 2;
        if (n % i == 0) {
            return false;
        }
        i += 4;
    }

    return true;
}

void main() {
    int beg = 2;
    int end = 1_000_000;
    int count = 0;

    // safe primes
    ///////////////////////////////////////////

    writeln("First 35 safe primes:");
    foreach (i; beg..end) {
        if (isPrime(i) && isPrime((i - 1) / 2)) {
            if (count < 35) {
                write(i, ' ');
            }
            count++;
        }
    }
    writefln("\nThere are %5d safe primes below %8d", count, end);

    beg = end;
    end *= 10;
    foreach (i; beg..end) {
        if (isPrime(i) && isPrime((i - 1) / 2)) {
            count++;
        }
    }
    writefln("There are %5d safe primes below %8d", count, end);

    // unsafe primes
    ///////////////////////////////////////////

    beg = 2;
    end = 1_000_000;
    count = 0;
    writeln("\nFirst 40 unsafe primes:");
    foreach (i; beg..end) {
        if (isPrime(i) && !isPrime((i - 1) / 2)) {
            if (count < 40) {
                write(i, ' ');
            }
            count++;
        }
    }
    writefln("\nThere are %6d unsafe primes below %9d", count, end);

    beg = end;
    end *= 10;
    foreach (i; beg..end) {
        if (isPrime(i) && !isPrime((i - 1) / 2)) {
            count++;
        }
    }
    writefln("There are %6d unsafe primes below %9d", count, end);
}
