import std.stdio, std.algorithm, std.functional, std.range;

int Q(int n) {
    assert(n > 0);
    alias memoize!Q mQ;
    if (n == 1 || n == 2)
        return 1;
    else
        return mQ(n - mQ(n - 1)) + mQ(n - mQ(n - 2));
}

void main() {
    writeln("Q(n) for n = [1..10] is: ", map!Q(iota(1, 11)));
    writeln("Q(1000) = ", Q(1000));
    writefln("Q(i) is less than Q(i-1) for i [2..100_000] %d times.",
             count!(i => Q(i) < Q(i-1))(iota(2, 100_001)));
}
