import std.stdio, std.math;

void yinYang(in int r) {
    foreach (immutable y; -r .. r + 1) {
        foreach (immutable x; -2 * r .. 2 * r + 1) {
            enum circle = (in int c, in int r) pure nothrow =>
                r ^^ 2 >= (x / 2) ^^ 2 + (y - c) ^^ 2;
            write(circle(-r / 2, r / 6) ? '#' :
                  circle( r / 2, r / 6) ? '.' :
                  circle(-r / 2, r / 2) ? '.' :
                  circle( r / 2, r / 2) ? '#' :
                  circle(     0, r)     ? "#."[x < 0] :
                                          ' ');
        }
        writeln;
    }
}

void main() {
    16.yinYang;
}
