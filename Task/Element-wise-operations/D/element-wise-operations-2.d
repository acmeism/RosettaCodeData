import std.stdio, std.typetuple, std.traits;

T[][] elementwise(string op, T, U)(in T[][] A, in U B)
@safe pure nothrow
if (isNumeric!U || (isArray!U && isArray!(ForeachType!U) &&
  isNumeric!(ForeachType!(ForeachType!U)))) {
    static if (!isNumeric!U)
        assert(A.length == B.length);
    if (!A.length)
        return null;
    auto R = new typeof(return)(A.length, A[0].length);

    foreach (immutable r, const row; A)
        static if (isNumeric!U) {
            R[r][] = mixin("row[] " ~ op ~ "B");
        } else {
            assert(row.length == B[r].length);
            R[r][] = mixin("row[] " ~ op ~ "B[r][]");
        }

    return R;
}

void main() {
    /*immutable*/ const matrix = [[3, 5, 7],
                                  [1, 2, 3],
                                  [2, 4, 6]];
    enum scalar = 2;
    enum matFormat = "[%([%(%d, %)],\n %)]]\n";

    foreach (op; TypeTuple!("+", "-", "*", "/", "^^")) {
        writeln(op, ":");
        writefln(matFormat, elementwise!op(matrix, scalar));
        writefln(matFormat, elementwise!op(matrix, matrix));
    }
}
