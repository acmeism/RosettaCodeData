import std.algorithm;
import std.range;
import std.stdio;
import std.typecons;

alias Transition = Tuple!(int, int);

bool isPrime(int n) {
    if (n < 2) return false;
    if (n % 2 == 0) return n == 2;
    if (n % 3 == 0) return n == 3;
    int d = 5;
    while (d*d <= n) {
        if (n%d == 0) return false;
        d += 2;
        if (n%d == 0) return false;
        d += 4;
    }
    return true;
}

auto generatePrimes() {
    import std.concurrency;
    return new Generator!int({
        yield(2);
        int p = 3;
        while (p > 0) {
            if (isPrime(p)) {
                yield(p);
            }
            p += 2;
        }
    });
}

void main() {
    auto primes = generatePrimes().take(1_000_000).array;
    int[Transition] transMap;
    foreach (i; 0 .. primes.length - 1) {
        auto transition = Transition(primes[i] % 10, primes[i + 1] % 10);
        if (transition in transMap) {
            transMap[transition] += 1;
        } else {
            transMap[transition] = 1;
        }
    }
    auto sortedTransitions = transMap.keys.multiSort!(q{a[0] < b[0]}, q{a[1] < b[1]});
    writeln("First 1,000,000 primes. Transitions prime % 10 -> next-prime % 10.");
    foreach (trans; sortedTransitions) {
        writef("%s -> %s  count: %5d", trans[0], trans[1], transMap[trans]);
        writefln("  frequency: %4.2f%%", transMap[trans] / 10_000.0);
    }
}
