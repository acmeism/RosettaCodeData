import std.stdio, std.traits;

ReturnType!TF series(TF)(TF func, int end, int start=1)
pure nothrow @safe @nogc {
    typeof(return) sum = 0;
    foreach (immutable i; start .. end + 1)
        sum += func(i);
    return sum;
}

void main() {
    writeln("Sum: ", series((in int n) => 1.0L / (n ^^ 2), 1_000));
}
