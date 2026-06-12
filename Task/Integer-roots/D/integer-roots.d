import std.bigint;
import std.stdio;

auto iRoot(BigInt b, int n) in {
    assert(b >=0 && n > 0);
} body {
    if (b < 2) return b;
    auto n1 = n - 1;
    auto n2 = BigInt(n);
    auto n3 = BigInt(n1);
    auto c = BigInt(1);
    auto d = (n3 + b) / n2;
    auto e = (n3 * d + b / d^^n1) / n2;
    while (c != d && c != e) {
        c = d;
        d = e;
        e = (n3 * e + b / e^^n1) / n2;
    }
    if (d < e) return d;
    return e;
}

void main() {
    auto b = BigInt(8);
    writeln("3rd root of 8 = ", b.iRoot(3));
    b = BigInt(9);
    writeln("3rd root of 9 = ", b.iRoot(3));
    b = BigInt(100)^^2000*2;
    writeln("First 2001 digits of the square root of 2: ", b.iRoot(2));
}
