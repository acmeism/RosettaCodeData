import std.bigint;
import std.stdio;

BigInt fact(long n) {
    BigInt f = 1;
    for (int i = 2; i <= n; i++) {
        f *= i;
    }
    return f;
}

bool isPrime(long p) {
    if (p <= 1) {
        return false;
    }
    return (fact(p - 1) + 1) % p == 0;
}

void main() {
    writeln("Primes less than 100 testing by Wilson's Theorem");
    foreach (i; 0 .. 101) {
        if (isPrime(i)) {
            write(i, ' ');
        }
    }
    writeln;
}
