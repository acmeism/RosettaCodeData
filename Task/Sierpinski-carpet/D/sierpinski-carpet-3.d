import std.stdio, std.algorithm, std.range, std.conv;

string sierpinskiCarpet(in int n) /*pure nothrow*/ {
    static bool inCarpet(int x, int y) pure nothrow {
        while (x != 0 && y != 0) {
            if (x % 3 == 1 && y % 3 == 1)
                return false;
            x /= 3;
            y /= 3;
        }
        return true;
    }

    return iota(3 ^^ n)
           .map!(i => iota(3 ^^ n)
                      .map!(j=> cast(dchar)(inCarpet(i,j)? '#' : ' ')))
           .joiner("\n")
           .text;
}

void main() {
    3.sierpinskiCarpet.writeln;
}
