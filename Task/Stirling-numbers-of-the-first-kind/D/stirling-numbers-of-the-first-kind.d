import std.bigint;
import std.functional;
import std.stdio;

alias sterling1 = memoize!sterling1Impl;
BigInt sterling1Impl(int n, int k) {
    if (n == 0 && k == 0) {
        return BigInt(1);
    }
    if (n > 0 && k == 0) {
        return BigInt(0);
    }
    if (k > n) {
        return BigInt(0);
    }
    return sterling1(n - 1, k - 1) + (n - 1) * sterling1(n - 1, k);
}

void main() {
    writeln("Unsigned Stirling numbers of the first kind:");
    int max = 12;
    write("n/k");
    foreach (n; 0 .. max + 1) {
        writef("%10d", n);
    }
    writeln;
    foreach (n; 0 .. max + 1) {
        writef("%-3d", n);
        foreach (k; 0 .. n + 1) {
            writef("%10s", sterling1(n, k));
        }
        writeln;
    }
    writeln("The maximum value of S1(100, k) = ");
    auto previous = BigInt(0);
    foreach (k; 1 .. 101) {
        auto current = sterling1(100, k);
        if (previous < current) {
            previous = current;
        } else {
            import std.conv;

            writeln(previous);
            writefln("(%d digits, k = %d)", previous.to!string.length, k - 1);
            break;
        }
    }
}
