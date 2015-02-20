void main() {
    import std.stdio, std.algorithm, std.range, std.conv;

    const(int)[] memo;
    size_t addNum;

    void setHead(int[] head) nothrow @safe {
        memo = head;
        addNum = head.length;
    }

    int fibber(in size_t n) nothrow @safe {
        if (n >= memo.length)
            memo ~= iota(n - addNum, n).map!fibber.sum;
        return memo[n];
    }

    setHead([1, 1]);
    10.iota.map!fibber.writeln;
    setHead([2, 1]);
    10.iota.map!fibber.writeln;

    const prefixes = "fibo tribo tetra penta hexa hepta octo nona deca";
    foreach (immutable n, const name; prefixes.split.enumerate(2)) {
        setHead(1 ~ iota(n - 1).map!q{2 ^^ a}.array);
        writefln("n=%2d, %5snacci -> %(%d %) ...", n, name,
                 15.iota.map!fibber);
    }
}
