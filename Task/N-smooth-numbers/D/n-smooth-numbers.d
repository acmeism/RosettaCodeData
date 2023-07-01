import std.algorithm;
import std.bigint;
import std.exception;
import std.range;
import std.stdio;

BigInt[] primes;
int[] smallPrimes;

bool isPrime(BigInt value) {
    if (value < 2) return false;

    if (value % 2 == 0) return value == 2;
    if (value % 3 == 0) return value == 3;

    if (value % 5 == 0) return value == 5;
    if (value % 7 == 0) return value == 7;

    if (value % 11 == 0) return value == 11;
    if (value % 13 == 0) return value == 13;

    if (value % 17 == 0) return value == 17;
    if (value % 19 == 0) return value == 19;

    if (value % 23 == 0) return value == 23;

    BigInt t = 29;
    while (t * t < value) {
        if (value % t == 0) return false;
        value += 2;

        if (value % t == 0) return false;
        value += 4;
    }

    return true;
}

// cache all primes up to 521
void init() {
    primes ~= BigInt(2);
    smallPrimes ~= 2;

    BigInt i = 3;
    while (i <= 521) {
        if (isPrime(i)) {
            primes ~= i;
            if (i <= 29) {
                smallPrimes ~= i.toInt;
            }
        }
        i += 2;
    }
}

BigInt[] nSmooth(int n, int size)
in {
    enforce(n >= 2 && n <= 521, "n must be between 2 and 521");
    enforce(size > 1, "size must be at least 1");
}
do {
    BigInt bn = n;
    bool ok = false;
    foreach (prime; primes) {
        if (bn == prime) {
            ok = true;
            break;
        }
    }
    enforce(ok, "n must be a prime number");

    BigInt[] ns;
    ns.length = size;
    ns[] = BigInt(0);
    ns[0] = 1;

    BigInt[] next;
    foreach(prime; primes) {
        if (prime > bn) {
            break;
        }
        next ~= prime;
    }

    int[] indicies;
    indicies.length = next.length;
    indicies[] = 0;
    foreach (m; 1 .. size) {
        ns[m] = next.reduce!min;
        foreach (i,v; indicies) {
            if (ns[m] == next[i]) {
                indicies[i]++;
                next[i] = primes[i] * ns[indicies[i]];
            }
        }
    }

    return ns;
}

void main() {
    init();

    foreach (i; smallPrimes) {
        writeln("The first ", i, "-smooth numbers are:");
        writeln(nSmooth(i, 25));
        writeln;
    }
    foreach (i; smallPrimes.drop(1)) {
        writeln("The 3,000th to 3,202 ", i, "-smooth numbers are:");
        writeln(nSmooth(i, 3_002).drop(2_999));
        writeln;
    }
    foreach (i; [503, 509, 521]) {
        writeln("The 30,000th to 30,019 ", i, "-smooth numbers are:");
        writeln(nSmooth(i, 30_019).drop(29_999));
        writeln;
    }
}
