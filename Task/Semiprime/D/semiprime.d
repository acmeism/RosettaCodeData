bool semiprime(long n) pure nothrow @safe @nogc {
    auto nf = 0;
    foreach (immutable i; 2 .. n + 1) {
        while (n % i == 0) {
            if (nf == 2)
                return false;
            nf++;
            n /= i;
        }
    }
    return nf == 2;
}

void main() {
    import std.stdio;

    foreach (immutable n; 1675 .. 1681)
        writeln(n, " -> ", n.semiprime);
}
