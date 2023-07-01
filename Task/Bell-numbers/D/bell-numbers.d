import std.array : uninitializedArray;
import std.bigint;
import std.stdio : writeln, writefln;

auto bellTriangle(int n) {
    auto tri = uninitializedArray!(BigInt[][])(n);
    foreach (i; 0..n) {
        tri[i] = uninitializedArray!(BigInt[])(i);
        tri[i][] = BigInt(0);
    }
    tri[1][0] = 1;
    foreach (i; 2..n) {
        tri[i][0] = tri[i - 1][i - 2];
        foreach (j; 1..i) {
            tri[i][j] = tri[i][j - 1] + tri[i - 1][j - 1];
        }
    }
    return tri;
}

void main() {
    auto bt = bellTriangle(51);
    writeln("First fifteen and fiftieth Bell numbers:");
    foreach (i; 1..16) {
        writefln("%2d: %d", i, bt[i][0]);
    }
    writeln("50: ", bt[50][0]);
    writeln;
    writeln("The first ten rows of Bell's triangle:");
    foreach (i; 1..11) {
        writeln(bt[i]);
    }
}
