void main() {
    import std.stdio, std.file;

    immutable ab = "sum_input.txt".slurp!(int, int)("%d %d")[0];
    "sum_output.txt".File("w").writeln(ab[0] + ab[1]);
}
