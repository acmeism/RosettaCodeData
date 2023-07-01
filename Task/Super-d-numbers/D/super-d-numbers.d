import std.bigint;
import std.conv;
import std.stdio;
import std.string;

void main() {
    auto rd = ["22", "333", "4444", "55555", "666666", "7777777", "88888888", "999999999"];
    BigInt one = 1;
    BigInt nine = 9;

    for (int ii = 2; ii <= 9; ii++) {
        writefln("First 10 super-%d numbers:", ii);
        auto count = 0;

        inner:
        for (BigInt j = 3; ; j++) {
            auto k = ii * j ^^ ii;
            auto ix = k.to!string.indexOf(rd[ii-2]);
            if (ix >= 0) {
                count++;
                write(j, ' ');
                if (count == 10) {
                    writeln();
                    writeln();
                    break inner;
                }
            }
        }
    }
}
