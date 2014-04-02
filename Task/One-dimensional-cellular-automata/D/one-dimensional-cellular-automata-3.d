void main() {
    import std.stdio, std.algorithm, std.range, std.bitmanip;

    immutable initial = "__###_##_#_#_#_#__#___";
    enum nGenerations = 10;
    BitArray A, B;
    A.init(initial.map!(c => c == '#').array);
    B.length = initial.length;

    foreach (immutable _; 0 .. nGenerations) {
        //A.map!(b => b ? '#' : '_').writeln;
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
