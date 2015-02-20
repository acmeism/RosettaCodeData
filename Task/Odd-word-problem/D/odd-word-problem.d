bool doChar(in bool odd, in void delegate() nothrow f=null) nothrow {
    import core.stdc.stdio, std.ascii;

    immutable int c = getchar;
    if (!odd)
        c.putchar;
    if (c.isAlpha)
        return doChar(odd, { c.putchar; if (f) f(); });
    if (odd) {
        if (f) f();
        c.putchar;
    }
    return c != '.';
}

void main() {
    bool i = true;
    while (doChar(i = !i)) {}
}
