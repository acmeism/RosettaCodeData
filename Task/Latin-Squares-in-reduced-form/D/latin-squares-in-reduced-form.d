import std.algorithm;
import std.array;
import std.range;
import std.stdio;

alias matrix = int[][];

auto dList(int n, int start) {
    start--;    // use 0 basing
    auto a = iota(0, n).array;
    a[start] = a[0];
    a[0] = start;
    sort(a[1..$]);
    auto first = a[1];
    // recursive closure permutes a[1:]
    matrix r;
    void recurse(int last) {
        if (last == first) {
            // bottom of recursion. you get here once for each permutation.
            // test if permutation is deranged.
            foreach (j,v; a[1..$]) {
                if (j + 1 == v) {
                    return; //no, ignore it
                }
            }
            // yes, save a copy with 1 based indexing
            auto b = a.map!"a+1".array;
            r ~= b;
            return;
        }
        for (int i = last; i >= 1; i--) {
            swap(a[i], a[last]);
            recurse(last -1);
            swap(a[i], a[last]);
        }
    }
    recurse(n - 1);
    return r;
}

ulong reducedLatinSquares(int n, bool echo) {
    if (n <= 0) {
        if (echo) {
            writeln("[]\n");
        }
        return 0;
    } else if (n == 1) {
        if (echo) {
            writeln("[1]\n");
        }
        return 1;
    }

    matrix rlatin = uninitializedArray!matrix(n);
    foreach (i; 0..n) {
        rlatin[i] = uninitializedArray!(int[])(n);
    }
    // first row
    foreach (j; 0..n) {
        rlatin[0][j] = j + 1;
    }

    ulong count;
    void recurse(int i) {
        auto rows = dList(n, i);

        outer:
        foreach (r; 0..rows.length) {
            rlatin[i-1] = rows[r].dup;
            foreach (k; 0..i-1) {
                foreach (j; 1..n) {
                    if (rlatin[k][j] == rlatin[i - 1][j]) {
                        if (r < rows.length - 1) {
                            continue outer;
                        }
                        if (i > 2) {
                            return;
                        }
                    }
                }
            }
            if (i < n) {
                recurse(i + 1);
            } else {
                count++;
                if (echo) {
                    printSquare(rlatin, n);
                }
            }
        }
    }

    // remaining rows
    recurse(2);
    return count;
}

void printSquare(matrix latin, int n) {
    foreach (row; latin) {
        writeln(row);
    }
    writeln;
}

ulong factorial(ulong n) {
    if (n == 0) {
        return 1;
    }
    ulong prod = 1;
    foreach (i; 2..n+1) {
        prod *= i;
    }
    return prod;
}

void main() {
    writeln("The four reduced latin squares of order 4 are:\n");
    reducedLatinSquares(4, true);

    writeln("The size of the set of reduced latin squares for the following orders");
    writeln("and hence the total number of latin squares of these orders are:\n");
    foreach (n; 1..7) {
        auto size = reducedLatinSquares(n, false);
        auto f = factorial(n - 1);
        f *= f * n * size;
        writefln("Order %d: Size %-4d x %d! x %d! => Total %d", n, size, n, n - 1, f);
    }
}
