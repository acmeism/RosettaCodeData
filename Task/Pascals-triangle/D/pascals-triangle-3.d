import std.stdio, std.string, std.array, std.format;

string Pascal(alias dg, T, T initValue)(int n) {
    string output;

    void append(in T[] l) {
        output ~= " ".replicate((n - l.length + 1) * 2);
        foreach (e; l)
            output ~= format("%4s", format("%4s", e));
        output ~= "\n";
    }

    if (n > 0) {
        T[][] lines = [[initValue]];
        append(lines[0]);
        foreach (i; 1 .. n) {
            lines ~= lines[i - 1] ~ initValue; // length + 1
            foreach (int j; 1 .. lines[i-1].length)
                lines[i][j] = dg(lines[i-1][j], lines[i-1][j-1]);
            append(lines[i]);
        }
    }
    return output;
}

string delegate(int n) genericPascal(alias dg, T, T initValue)() {
    mixin Pascal!(dg, T, initValue);
    return &Pascal;
}

void main() {
    auto pascal = genericPascal!((int a, int b) => a + b, int, 1)();
    static char xor(char a, char b) { return a == b ? '_' : '*'; }
    auto sierpinski = genericPascal!(xor, char, '*')();

    foreach (i; [1, 5, 9])
        writef(pascal(i));
    // an order 4 sierpinski triangle is a 2^4 lines generic
    // Pascal triangle with xor operation
    foreach (i; [16])
        writef(sierpinski(i));
}
