import std.stdio, std.algorithm, std.conv, std.string,
       std.typetuple, std.traits;

T[][] elementwise(string op, T, U)(in T[][] A, in U B)
@safe pure /*nothrow*/
if (isNumeric!U || (isArray!U && isArray!(ForeachType!U) &&
  isNumeric!(ForeachType!(ForeachType!U)))) {
    static if (!isNumeric!U)
        assert(A.length == B.length);
    if (!A.length)
        return null;
    auto R = new typeof(return)(A.length, A[0].length);

    foreach (r, row; A)
        static if (isNumeric!U) {
            R[r][] = mixin("row[] " ~ op ~ "B");
        } else {
            assert(row.length == B[r].length);
            R[r][] = mixin("row[] " ~ op ~ "B[r][]");
        }

    return R;
}

string matRep(T)(in T[][] m) /*@safe pure nothrow*/ {
    return "[" ~ join(map!text(m), ",\n ") ~ "]";
}

void main() {
    const matrix = [[3, 5, 7],
                    [1, 2, 3],
                    [2, 4, 6]];
    const scalar = 2;

    foreach (op; TypeTuple!("+", "-", "*", "/", "^^")) {
        writeln(op, ":");
        writeln(matRep(elementwise!op(matrix, scalar)), "\n");
        writeln(matRep(elementwise!op(matrix, matrix)), "\n");
    }
}
