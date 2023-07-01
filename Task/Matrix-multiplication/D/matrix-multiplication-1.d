import std.stdio, std.string, std.conv, std.numeric,
       std.array, std.algorithm;

bool isRectangular(T)(in T[][] M) pure nothrow {
    return M.all!(row => row.length == M[0].length);
}

T[][] matrixMul(T)(in T[][] A, in T[][] B) pure nothrow
in {
    assert(A.isRectangular && B.isRectangular &&
           !A.empty && !B.empty && A[0].length == B.length);
} body {
    auto result = new T[][](A.length, B[0].length);
    auto aux = new T[B.length];

    foreach (immutable j; 0 .. B[0].length) {
        foreach (immutable k, const row; B)
            aux[k] = row[j];
        foreach (immutable i, const ai; A)
            result[i][j] = dotProduct(ai, aux);
    }

    return result;
}

void main() {
    immutable a = [[1, 2], [3, 4], [3, 6]];
    immutable b = [[-3, -8, 3,], [-2, 1, 4]];

    immutable form = "[%([%(%d, %)],\n %)]]";
    writefln("A = \n" ~ form ~ "\n", a);
    writefln("B = \n" ~ form ~ "\n", b);
    writefln("A * B = \n" ~ form, matrixMul(a, b));
}
