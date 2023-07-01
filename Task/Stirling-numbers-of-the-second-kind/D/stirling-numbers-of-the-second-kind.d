import std.bigint;
import std.conv;
import std.functional;
import std.stdio;

alias sterling2 = memoize!sterling2Impl;
BigInt sterling2Impl(int n, int k) {
    if (n == 0 && k == 0) {
        return BigInt(1);
    }
    if ((n > 0 && k == 0) || (n == 0 && k > 0)) {
        return BigInt(0);
    }
    if (n == k) {
        return BigInt(1);
    }
    if (k > n) {
        return BigInt(0);
    }

    return BigInt(k) * sterling2(n - 1, k) + sterling2(n - 1, k - 1);
}

void main() {
    writeln("Stirling numbers of the second kind:");
    int max = 12;

    write("n/k");
    for (int n = 0; n <= max; n++) {
        writef("%10d", n);
    }
    writeln;

    for (int n = 0; n <= max; n++) {
        writef("%-3d", n);
        for (int k = 0; k <= n; k++) {
            writef("%10s", sterling2(n, k));
        }
        writeln;
    }

    writeln("The maximum value of S2(100, k) = ");
    auto previous = BigInt(0);
    for (int k = 1; k <= 100; k++) {
        auto current = sterling2(100, k);
        if (current > previous) {
            previous = current;
        } else {
            writeln(previous);
            auto ps = previous.to!string;
            writefln("(%d digits, k = %d)", ps.length, k - 1);
            break;
        }
    }
}
