import std.stdio;

enum MAX = 120;

bool isPrime(int n) {
    if (n < 2) return false;
    if (n % 2 == 0) return n == 2;
    if (n % 3 == 0) return n == 3;
    int d = 5;
    while (d * d <= n) {
        if (n % d == 0) return false;
        d += 2;
        if (n % d == 0) return false;
        d += 4;
    }
    return true;
}

int primeFactorCount(int n) {
    if (n == 1) return 0;
    if (isPrime(n)) return 1;
    int count;
    int f = 2;
    while (true) {
        if (n % f == 0) {
            count++;
            n /= f;
            if (n == 1) return count;
            if (isPrime(n)) f = n;
        } else if (f >= 3) {
            f += 2;
        } else {
            f = 3;
        }
    }
}

void main() {
    writeln("The attractive numbers up to and including ", MAX, " are:");
    int i = 1;
    int count;
    while (i <= MAX) {
        int n = primeFactorCount(i);
        if (isPrime(n)) {
            writef("%4d", i);
            if (++count % 20 == 0) writeln;
        }
        ++i;
    }
    writeln;
}
