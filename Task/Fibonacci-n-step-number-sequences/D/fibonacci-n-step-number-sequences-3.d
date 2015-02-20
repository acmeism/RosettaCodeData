import std.stdio, std.algorithm, std.range, std.traits;

struct Fiblike(T) {
    T[] tail;

    int opApply(int delegate(immutable ref T) dg) {
        int result, pos;
        foreach (immutable x; tail) {
            result = dg(x);
            if (result)
                return result;
        }
        foreach (immutable i; tail.length.iota.cycle) {
            immutable x = tail.sum;
            result = dg(x);
            if (result)
                break;
            tail[i] = x;
        }
        return result;
    }
}

// std.range.take doesn't work with opApply.
ForeachType!It[] takeApply(It)(It iterable, in size_t n) {
    typeof(return) result;
    foreach (immutable x; iterable) {
        result ~= x;
        if (result.length == n)
            break;
    }
    return result;
}

void main() {
    Fiblike!int([1, 1]).takeApply(10).writeln;
    Fiblike!int([2, 1]).takeApply(10).writeln;

    const prefixes = "fibo tribo tetra penta hexa hepta octo nona deca";
    foreach (immutable n, const name; prefixes.split.enumerate(2)) {
        auto fib = Fiblike!int(1 ~ iota(n - 1).map!q{2 ^^ a}.array);
        writefln("n=%2d, %5snacci -> %s", n, name, fib.takeApply(15));
    }
}
