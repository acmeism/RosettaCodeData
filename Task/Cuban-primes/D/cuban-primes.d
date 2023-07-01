import std.math;
import std.stdio;

void main() {
    long[] primes = [3, 5];

    immutable cutOff = 200;
    immutable bigUn = 100_000;
    immutable chunks = 50;
    immutable little = bigUn / chunks;
    immutable tn = " cuban prime";
    writefln("The first %s%ss:", cutOff, tn);
    int c;
    bool showEach = true;
    long u;
    long v = 1;
    for (long i = 1; i > 0; ++i) {
        bool found;
        u += 6;
        v += u;
        int mx = cast(int)ceil(sqrt(cast(real)v));
        foreach (item; primes) {
            if (item > mx) break;
            if (v % item == 0) {
                found = true;
                break;
            }
        }
        if (!found) {
            c++;
            if (showEach) {
                for (auto z = primes[$-1] + 2; z <= v - 2; z += 2) {
                    bool fnd;
                    foreach (item; primes) {
                        if (item > mx) break;
                        if (z % item == 0) {
                            fnd = true;
                            break;
                        }
                    }
                    if (!fnd) {
                        primes ~= z;
                    }
                }
                primes ~= v;
                writef("%11d", v);
                if (c % 10 == 0) writeln;
                if (c == cutOff) {
                    showEach = false;
                    writef("\nProgress to the %sth%s: ", bigUn, tn);
                }
            }
            if (c % little == 0) {
                write('.');
                if (c == bigUn) {
                    break;
                }
            }
        }
    }
    writefln("\nThe %sth%s is %17s", c, tn, v);
}
