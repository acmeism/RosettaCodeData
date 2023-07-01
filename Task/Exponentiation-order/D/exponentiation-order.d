void main() {
    import std.stdio, std.math, std.algorithm;

    writefln("5 ^^ 3 ^^ 2          = %7d", 5 ^^ 3 ^^ 2);
    writefln("(5 ^^ 3) ^^ 2        = %7d", (5 ^^ 3) ^^ 2);
    writefln("5 ^^ (3 ^^ 2)        = %7d", 5 ^^ (3 ^^ 2));
    writefln("[5, 3, 2].reduce!pow = %7d", [5, 3, 2].reduce!pow);
}
