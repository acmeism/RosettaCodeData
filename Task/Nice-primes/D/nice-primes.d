import std.stdio;

bool isPrime(uint n) {
    if (n < 2) {
        return false;
    }
    if (n % 2 == 0) {
        return n == 2;
    }
    if (n % 3 == 0) {
        return n == 3;
    }
    for (uint p = 5; p * p <= n; p += 4) {
        if (n % p == 0) {
            return false;
        }
        p += 2;
        if (n % p == 0) {
            return false;
        }
    }
    return true;
}

uint digitalRoot(uint n) {
    return n == 0 ? 0 : 1 + (n - 1) % 9;
}

void main() {
    immutable from = 500;
    immutable to = 1000;
    writeln("Nice primes between ", from, " and ", to, ':');
    uint count;
    foreach (n; from .. to) {
        if (isPrime(digitalRoot(n)) && isPrime(n)) {
            count++;
            write(n);
            if (count % 10 == 0) {
                writeln;
            } else {
                write(' ');
            }
        }
    }
    writeln;
    writeln(count, " nice primes found.");
}
