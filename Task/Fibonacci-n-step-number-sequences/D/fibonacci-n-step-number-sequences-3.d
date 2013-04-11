import std.stdio, std.algorithm, std.range, std.traits;

struct Fiblike(T) {
    T[] tail;

    int opApply(int delegate(ref T) dg) {
        int result, pos;
        foreach (x; tail) {
            result = dg(x);
            if (result) return result;
        }
        foreach (i; cycle(iota(tail.length))) {
            auto x = tail.reduce!q{a + b}();
            result = dg(x);
            if (result) break;
            tail[i] = x;
        }
        return result;
    }
}

// std.range.take doesn't work with opApply
ForeachType!It[] takeApply(It)(It iterable, size_t n) {
    typeof(return) result;
    foreach (x; iterable) {
        result ~= x;
        if (result.length == n) break;
    }
    return result;
}

void main() {
    Fiblike!int([1, 1]).takeApply(10).writeln();
    Fiblike!int([2, 1]).takeApply(10).writeln();

    auto prefixes = "fibo tribo tetra penta hexa hepta octo nona deca";
    foreach (n, name; zip(iota(2, 11), prefixes.split())) {
        auto fib = Fiblike!int(1 ~ iota(n-1).map!q{2 ^^ a}().array());
        writefln("n=%2d, %5snacci -> %s", n, name, fib.takeApply(15));
    }
}
