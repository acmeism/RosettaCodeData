import std.stdio, std.algorithm, std.range, std.conv;

void main() {
    int[] memo;
    size_t addNum;

    void setHead(int[] head) nothrow {
        memo = head;
        addNum = head.length;
    }

    int fibber(in size_t n) /*nothrow*/ {
        if (n >= memo.length)
            memo ~= iota(n - addNum, n).map!fibber().reduce!q{a + b}();
        return memo[n];
    }

    setHead([1, 1]);
    iota(10).map!fibber().writeln();
    setHead([2, 1]);
    iota(10).map!fibber().writeln();

    auto prefixes = "fibo tribo tetra penta hexa hepta octo nona deca";
    foreach (n, name; zip(iota(2, 11), prefixes.split())) {
        setHead(1 ~ iota(n - 1).map!q{2 ^^ a}().array());
        auto items = iota(15).map!(i => text(fibber(i)))().join(" ");
        writefln("n=%2d, %5snacci -> %s ...", n, name, items);
    }
}
