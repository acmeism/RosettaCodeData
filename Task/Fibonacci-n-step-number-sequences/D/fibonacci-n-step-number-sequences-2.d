import std.stdio, std.algorithm, std.range, std.conv;

struct fiblike(T) {
    const(T)[] memo;
    immutable size_t addNum;

    this(in T[] start) /*nothrow*/ {
        this.memo = start.dup;
        this.addNum = start.length;
    }

    T opCall(in size_t n) /*nothrow*/ {
        if (n >= memo.length)
            memo ~= iota(n - addNum, n)
                    .map!(i => opCall(i))
                    .sum
                    .to!int;
        return memo[n];
    }
}

void main() {
    auto fibo = fiblike!int([1, 1]);
    iota(10).map!fibo.writeln;

    auto lucas = fiblike!int([2, 1]);
    iota(10).map!lucas.writeln;

    const prefixes = "fibo tribo tetra penta hexa hepta octo nona deca";
    //foreach (immutable n, const name; prefixes.split.enumerate(2)) {
    foreach (immutable n, name; iota(2, 11).zip(prefixes.split)) {
        auto fib = fiblike!int(1 ~ iota(n - 1).map!q{2 ^^ a}.array);
        writefln("n=%2d, %5snacci -> %(%d %) ...",
                 n, name, 15.iota.map!fib);
    }
}
