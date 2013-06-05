import std.stdio, std.algorithm, std.functional, std.range;

int Q(in int n) nothrow
in {
    assert(n > 0);
} body {
    alias mQ = memoize!Q;
    if (n == 1 || n == 2)
        return 1;
    else
        return mQ(n - mQ(n - 1)) + mQ(n - mQ(n - 2));
}

void main() {
    writeln("Q(n) for n = [1..10] is: ", iota(1, 11).map!Q);
    writeln("Q(1000) = ", Q(1000));
    writefln("Q(i) is less than Q(i-1) for i [2..100_000] %d times.",
             iota(2, 100_001).count!(i => Q(i) < Q(i - 1)));
}
