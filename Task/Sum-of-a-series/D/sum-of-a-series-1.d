import std.stdio, std.traits;

ReturnType!TF series(TF)(TF func, int end, int start=1) pure nothrow {
    typeof(return) sum = 0;
    foreach (i; start .. end + 1)
        sum += func(i);
    return sum;
}

void main() {
    writeln("Sum: ", series((int n) => 1.0L / (n ^^ 2), 1_000));
}
