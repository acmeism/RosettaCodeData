void main() {
    import std.stdio, std.algorithm, std.range, std.concurrency;

    immutable fibLike = (int[] tail) => new Generator!int({
        foreach (x; tail)
            yield(x);
        foreach (immutable i; tail.length.iota.cycle)
            yield(tail[i] = tail.sum);
    });

    foreach (seed; [[1, 1], [2, 1]])
        fibLike(seed).take(10).writeln;

    immutable prefixes = "fibo tribo tetra penta hexa hepta octo nona deca";
    foreach (immutable n, const name; prefixes.split.enumerate(2)) {
        auto fib = fibLike(1 ~ iota(n - 1).map!q{2 ^^ a}.array);
        writefln("n=%2d, %5snacci -> %(%s, %), ...", n, name, fib.take(15));
    }
}
