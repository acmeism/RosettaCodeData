import std.stdio, std.algorithm, std.range, std.conv, std.string,
       std.concurrency, permutations2, arithmetic_rational;

string solve(in int target, in int[] problem) {
    static struct T { Rational r; string e; }

    Generator!T computeAllOperations(in Rational[] L) {
        return new typeof(return)({
            if (!L.empty) {
                immutable x = L[0];
                if (L.length == 1) {
                    yield(T(x, x.text));
                } else {
                    foreach (const o; computeAllOperations(L.dropOne)) {
                        immutable y = o.r;
                        auto sub = [T(x * y, "*"), T(x + y, "+"), T(x - y, "-")];
                        if (y) sub ~= [T(x / y, "/")];
                        foreach (const e; sub)
                            yield(T(e.r, format("(%s%s%s)", x, e.e, o.e)));
                    }
                }
            }
        });
    }

    foreach (const p; problem.map!Rational.array.permutations!false)
        foreach (const sol; computeAllOperations(p))
            if (sol.r == target)
                return sol.e;
    return "No solution";
}

void main() {
    foreach (const prob; [[6, 7, 9, 5], [3, 3, 8, 8], [1, 1, 1, 1]])
        writeln(prob, ": ", solve(24, prob));
}
