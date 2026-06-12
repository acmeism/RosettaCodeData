import std.array;

struct PermutationsWithRepetitions(T) {
    const T[] data;
    const int n;

    int opApply(int delegate(ref T[]) dg) {
        int result;
        T[] aux;

        if (n == 1) {
            foreach (el; data) {
                aux = [el];
                result = dg(aux);
                if (result) goto END;
            }
        } else {
            foreach (el; data) {
                foreach (p; PermutationsWithRepetitions(data, n - 1)) {
                    aux = el ~ p;
                    result = dg(aux);
                    if (result) goto END;
                }
            }
        }

        END:
        return result;
    }
}

auto permutationsWithRepetitions(T)(T[] data, in int n) pure nothrow
in {
    assert(!data.empty && n > 0);
} body {
    return PermutationsWithRepetitions!T(data, n);
}

void main() {
    import std.stdio, std.array;
    [1, 2, 3].permutationsWithRepetitions(2).array.writeln;
}
