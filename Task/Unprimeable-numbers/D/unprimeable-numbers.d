import std.algorithm;
import std.array;
import std.conv;
import std.range;
import std.stdio;

immutable MAX = 10_000_000;
bool[] primes;

bool[] sieve(int limit) {
    bool[] p = uninitializedArray!(bool[])(limit);
    p[0..2] = false;
    p[2..$] = true;
    foreach (i; 2..limit) {
        if (p[i]) {
            for (int j = 2 * i; j < limit; j += i) {
                p[j] = false;
            }
        }
    }
    return p;
}

string replace(CHAR)(CHAR[] str, int position, CHAR value) {
    str[position] = value;
    return str.idup;
}

bool unPrimeable(int n) {
    if (primes[n]) {
        return false;
    }
    auto test = n.to!string;
    foreach (i; 0 .. test.length) {
        for (char j = '0'; j <= '9'; j++) {
            auto r = replace(test.dup, i, j);
            if (primes[r.to!int]) {
                return false;
            }
        }
    }
    return true;
}

void displayUnprimeableNumbers(int maxCount) {
    int test = 1;
    for (int count = 0; count < maxCount;) {
        test++;
        if (unPrimeable(test)) {
            count++;
            write(test, ' ');
        }
    }
    writeln;
}

int nthUnprimeableNumber(int maxCount) {
    int test = 1;
    for (int count = 0; count < maxCount;) {
        test++;
        if (unPrimeable(test)) {
            count++;
        }
    }
    return test;
}

int[] genLowest() {
    int[] lowest = uninitializedArray!(int[])(10);
    lowest[] = 0;

    int count = 0;
    int test = 1;
    while (count < 10) {
        test++;
        if (unPrimeable(test) && lowest[test % 10] == 0) {
            lowest[test % 10] = test;
            count++;
        }
    }

    return lowest;
}

void main() {
    primes = sieve(MAX);

    writeln("First 35 unprimeable numbers:");
    displayUnprimeableNumbers(35);
    writeln;

    int n = 600;
    writefln("The %dth unprimeable number = %,d", n, nthUnprimeableNumber(n));
    writeln;

    writeln("Least unprimeable number that ends in:");
    foreach (i,v; genLowest()) {
        writefln(" %d is %,d", i, v);
    }
}
