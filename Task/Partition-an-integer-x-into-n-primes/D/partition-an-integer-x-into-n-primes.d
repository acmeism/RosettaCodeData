import std.array : array;
import std.range : take;
import std.stdio;

bool isPrime(int n) {
    if (n < 2) return false;
    if (n % 2 == 0) return n == 2;
    if (n % 3 == 0) return n == 3;

    int d = 5;
    while (d*d <= n) {
        if (n % d == 0) return false;
        d += 2;
        if (n % d == 0) return false;
        d += 4;
    }
    return true;
}

auto generatePrimes() {
    struct Seq {
        int p = 2;

        bool empty() {
            return p < 0;
        }

        int front() {
            return p;
        }

        void popFront() {
            if (p==2) {
                p++;
            } else {
                p += 2;
                while (!empty && !p.isPrime) {
                    p += 2;
                }
            }
        }
    }

    return Seq();
}

bool findCombo(int k, int x, int m, int n, int[] combo) {
    import std.algorithm : map, sum;
    auto getPrime = function int(int idx) => primes[idx];

    if (k >= m) {
        if (combo.map!getPrime.sum == x) {
            auto word = (m > 1) ? "primes" : "prime";
            writef("Partitioned %5d with %2d %s ", x, m, word);
            foreach (i; 0..m) {
                write(primes[combo[i]]);
                if (i < m-1) {
                    write('+');
                } else {
                    writeln();
                }
            }
            return true;
        }
    } else {
        foreach (j; 0..n) {
            if (k==0 || j>combo[k-1]) {
                combo[k] = j;
                bool foundCombo = findCombo(k+1, x, m, n, combo);
                if (foundCombo) {
                    return true;
                }
            }
        }
    }
    return false;
}

void partition(int x, int m) {
    import std.exception : enforce;
    import std.algorithm : filter;
    enforce(x>=2 && m>=1 && m<x);

    auto lessThan = delegate int(int a) => a<=x;
    auto filteredPrimes = primes.filter!lessThan.array;
    auto n = filteredPrimes.length;
    enforce(n>=m, "Not enough primes");

    int[] combo = new int[m];
    if (!findCombo(0, x, m, n, combo)) {
        auto word = (m > 1) ? "primes" : "prime";
        writefln("Partitioned %5d with %2d %s: (not possible)", x, m, word);
    }
}

int[] primes;
void main() {
    // generate first 50,000 and call it good
    primes = generatePrimes().take(50_000).array;

    auto a = [
        [99809,  1],
        [   18,  2],
        [   19,  3],
        [   20,  4],
        [ 2017, 24],
        [22699,  1],
        [22699,  2],
        [22699,  3],
        [22699,  4],
        [40355,  3]
    ];

    foreach(p; a) {
        partition(p[0], p[1]);
    }
}
