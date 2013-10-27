import std.stdio, std.string, std.conv, std.numeric, std.array,
       std.algorithm, std.traits;

alias TMMul_helper(M1, M2) = Unqual!(ForeachType!(ForeachType!M1))
                             [M2.init[0].length][M1.length];

void matrixMul(T, T2, size_t k, size_t m, size_t n)
              (in ref T[m][k] A, in ref T[n][m] B,
               /*out*/ ref T2[n][k] result) pure nothrow
if (is(T2 == Unqual!T)) {
    T2[m] aux;
    foreach (immutable j; 0 .. n) {
        foreach (immutable k, const row; B)
            aux[k] = row[j];
        foreach (immutable i, const ai; A)
            result[i][j] = dotProduct(ai, aux);
    }
}

void main() {
    immutable int[2][3] a = [[1, 2], [3, 4], [3, 6]];
    immutable int[3][2] b = [[-3, -8, 3,], [-2, 1, 4]];

    enum form = "[%([%(%d, %)],\n %)]]";
    writefln("A = \n" ~ form ~ "\n", a);
    writefln("B = \n" ~ form ~ "\n", b);
    TMMul_helper!(typeof(a), typeof(b)) result = void;
    matrixMul(a, b, result);
    writefln("A * B = \n" ~ form, result);
}
