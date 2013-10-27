import std.stdio, std.algorithm, std.array, std.range, std.bitmanip;

immutable initial = "__###_##_#_#_#_#__#___";
enum numGenerations = 10;

void main() {
    BitArray A, B;
    A.length = initial.length;
    B.length = initial.length;

    // auto A = BitArray(initial.map!(c => c == '#'));
    foreach (immutable i, immutable c; initial)
        A[i] = c == '#';

    foreach (immutable _; 0 .. numGenerations) {
        //A.map!(b => b ? '#' : '_').weiteln;
        //foreach (immutable i, immutable b; A) {
        foreach (immutable i; 1 .. A.length - 1) {
            "_#"[A[i]].write;
            immutable val = (cast(uint)A[i - 1] << 2) |
                            (cast(uint)A[i] << 1) |
                            cast(uint)A[i + 1];
            B[i] = val == 3 || val == 5 || val == 6;
        }

        writeln;
        A.swap(B);
    }
}
