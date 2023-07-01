import std.stdio, std.range, std.array, std.numeric, std.algorithm;

T[][] matMul(T)(in T[][] A, in T[][] B) pure nothrow /*@safe*/ {
    const Bt = B[0].length.iota.map!(i=> B.transversal(i).array).array;
    return A.map!(a => Bt.map!(b => a.dotProduct(b)).array).array;
}

void main() {
    immutable a = [[1, 2], [3, 4], [3, 6]];
    immutable b = [[-3, -8, 3,], [-2, 1, 4]];

    immutable form = "[%([%(%d, %)],\n %)]]";
    writefln("A = \n" ~ form ~ "\n", a);
    writefln("B = \n" ~ form ~ "\n", b);
    writefln("A * B = \n" ~ form, matMul(a, b));
}
