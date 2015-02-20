void showSierpinskiTriangle(in uint order) nothrow @safe @nogc {
    import core.stdc.stdio: putchar;

    foreach_reverse (immutable y; 0 .. 2 ^^ order) {
        foreach (immutable _; 0 .. y)
            ' '.putchar;
        foreach (immutable x; 0 .. 2 ^^ order - y) {
            putchar((x & y) ? ' ' : '*');
            ' '.putchar;
        }
        '\n'.putchar;
    }
}

void main() nothrow @safe @nogc {
    4.showSierpinskiTriangle;
}
