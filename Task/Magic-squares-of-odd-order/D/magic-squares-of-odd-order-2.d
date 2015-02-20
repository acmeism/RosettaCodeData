import std.stdio, std.conv, std.string, std.range, std.algorithm;

uint[][] magicSquare(immutable uint n) pure nothrow @safe
in {
    assert(n > 0 && n % 2 == 1);
} out(mat) {
    // mat is square of the right size.
    assert(mat.length == n);
    assert(mat.all!(row => row.length == n));

    immutable magic = mat[0].sum;

    // The sum of all rows is the same magic number.
    assert(mat.all!(row => row.sum == magic));

    // The sum of all columns is the same magic number.
    //assert(mat.transposed.all!(col => col.sum == magic));
    assert(mat.dup.transposed.all!(col => col.sum == magic));

    // The sum of the main diagonals is the same magic number.
    assert(mat.enumerate.map!(ir => ir[1][ir[0]]).sum == magic);
    //assert(mat.enumerate.map!({i, r} => r[i]).sum == magic);
    assert(mat.enumerate.map!(ir => ir[1][ir[0]]).sum == magic);
} body {
    enum M = (in uint x) pure nothrow @safe @nogc => (x + n - 1) % n;
    auto m = new uint[][](n, n);

    uint i = 0;
    uint j = n / 2;
    foreach (immutable uint k; 1 .. n ^^ 2 + 1) {
        m[i][j] = k;
        if (m[M(i)][M(j)]) {
            i = (i + 1) % n;
        } else {
            i = M(i);
            j = M(j);
        }
    }

    return m;
}

void showSquare(in uint[][] m)
in {
    assert(m.all!(row => row.length == m[0].length));
} body {
    immutable maxLen = text(m.length ^^ 2).length.text;
    writefln("%(%(%" ~ maxLen ~ "d %)\n%)", m);
    writeln("\nMagic constant: ", m[0].sum);
}

int main(in string[] args) {
    if (args.length == 1) {
        5.magicSquare.showSquare;
        return 0;
    } else if (args.length == 2) {
        immutable n = args[1].to!uint;
        if (n > 0 && n % 2 == 1) {
            n.magicSquare.showSquare;
            return 0;
        }
    }

    stderr.writefln("Requires n odd and larger than 0.");
    return 1;
}
