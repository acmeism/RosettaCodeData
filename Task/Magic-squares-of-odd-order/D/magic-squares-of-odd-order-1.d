void main(in string[] args) {
    import std.stdio, std.conv, std.range, std.algorithm,std.exception;

    immutable n = args.length == 2 ? args[1].to!uint : 5;
    enforce(n > 0 && n % 2 == 1, "Only odd n > 1");
    immutable len = text(n ^^ 2).length.text;

    foreach (immutable r; 1 .. n + 1)
        writefln("%-(%" ~ len ~ "d %)",
                 iota(1, n + 1)
                 .map!(c => n * ((r + c - 1 + n / 2) % n) +
                            ((r + 2 * c - 2) % n)));

    writeln("\nMagic constant: ", (n * n + 1) * n / 2);
}
