import std.stdio, std.array;

char[][] sierpinskiCarpet(in size_t n) pure nothrow {
    auto mat = uninitializedArray!(typeof(return))(3 ^^ n, 3 ^^ n);

    foreach (immutable r, row; mat) {
        row[] = '#';
        foreach (immutable c, ref cell; row) {
            size_t r2 = r, c2 = c;
            while (r2 && c2) {
                if (r2 % 3 == 1 && c2 % 3 == 1) {
                    cell = ' ';
                    break;
                }
                r2 /= 3;
                c2 /= 3;
            }
        }
    }

    return mat;
}

void main() {
    writefln("%-(%s\n%)", 3.sierpinskiCarpet);
    7.sierpinskiCarpet.length.writeln;
}
